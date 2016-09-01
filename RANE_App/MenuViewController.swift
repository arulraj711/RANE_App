//
//  MenuViewController.swift
//  RANE_App
//
//  Created by cape start on 10/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import CoreData

class MenuViewController: UIViewController,UIActionSheetDelegate {

    @IBOutlet weak var menuNavigationBarItem: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var menuTableView: UITableView!
    var menuItems: [Menu]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let imageName = "nav_logo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.navigationItem.titleView = imageView
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.init(colorLiteralRed: 199/255, green: 199/255, blue: 205/255, alpha: 1).CGColor
        searchBar.enablesReturnKeyAutomatically = false
        self.menuItems = CoreDataController().getEntityInfoFromCoreData("Menu")
        self.menuTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomMenuCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let menu = self.menuItems![indexPath.row] 
//        print("menu object",menu.menuName,menu.menuId)
//        if let url = NSURL(string: menu.menuIconURL) {
//            if let data = NSData(contentsOfURL: url) {
//                cell.menuIconImage.image = UIImage(data: data)
//            }
//        }
        if(menu.menuId.integerValue == 101) {
            cell.menuIconImage.kf_setImageWithURL(NSURL(string:"http://www.3daspect.com.au/here/wp-content/themes/gds3daspect/images/contact-icon-black-phone-90x90.png")!, placeholderImage: nil)
        } else if(menu.menuId.integerValue == 102) {
            cell.menuIconImage.image = UIImage(named: "Logout")
        } else {
            cell.menuIconImage.kf_setImageWithURL(NSURL(string:menu.menuIconURL!)!, placeholderImage: nil)
        }
        
        
        
//        let menuImage = UIImage(named: items[indexPath.row])
//        cell.menuIconImage.image = menuImage
        cell.menuName.text = menu.menuName
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let menu = self.menuItems![indexPath.row]
        var activityTypeId:Int = 0
        if(menu.menuId == 6) {
            activityTypeId = 3
        } else if(menu.menuId == 9) {
            activityTypeId = 2
        }
        if(menu.menuId == 36){
            //Newsletter list #2-stage #36-live
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:NewsLetterViewController = storyboard.instantiateViewControllerWithIdentifier("newsLetterView") as! NewsLetterViewController
            vc.titleString = menu.menuName!
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if(menu.menuId == 35) {
            //Folder list #19-stage #35-live
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:FolderListViewController = storyboard.instantiateViewControllerWithIdentifier("folderListView") as! FolderListViewController
            vc.titleString = menu.menuName!
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if(menu.menuId == 21) {
            //Media analysis
            
        } else if(menu.menuId == 101) {
            let actionSheet = UIActionSheet(title: "Contact RANE", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Call +1-844-RUN-RANE")
            actionSheet.showInView(self.view)
            
        } else if(menu.menuId == 102) {
            //logout action
            CoreDataController().deleteAndResetStack()
            for viewCtlr in (self.navigationController?.viewControllers)! {
                if(viewCtlr.isKindOfClass(ViewController) == true) {
                    self.navigationController?.popToViewController(viewCtlr as! ViewController, animated: true)
                    break;
                }

            }
            
            NSUserDefaults.standardUserDefaults().setObject("", forKey: "securityToken")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
            vc.contentTypeId = menu.menuId.integerValue
            vc.titleString = menu.menuName!
            vc.activityTypeId = activityTypeId
            vc.isFromDailyDigest = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch (buttonIndex){
        case 0: break
        case 1:
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://+18447867263")!)
        default: break
            //Some code here..
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }
//
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        print("searchBarTextDidBeginEditing")
//    }
//    
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        print("searchBarTextDidEndEditing")
//    }
//    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if(searchBar.text?.characters.count != 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
            vc.titleString = searchBar.text!
            vc.contentTypeId = -200 //handle duplicate article list while searching
            vc.isFromDailyDigest = false
            vc.searchKeyword = searchBar.text!
                .stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
//
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchBar")
        if(searchBar.text?.characters.count == 0) {
            CoreDataController().deleteSearchedArtilces()
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
