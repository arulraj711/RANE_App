//
//  MenuViewController.swift
//  RANE_App
//
//  Created by cape start on 10/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import Kingfisher

class MenuViewController: UIViewController {

    @IBOutlet weak var menuNavigationBarItem: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var menuTableView: UITableView!
    var menuItems: [MenuObject]?
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
        menuItems = WebServiceManager.sharedInstance.menuItems
        print("menu items",menuItems);
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("listView")
//        self.navigationController?.pushViewController(vc, animated: false)
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
        
//        if let url = NSURL(string: menu.menuIconURL) {
//            if let data = NSData(contentsOfURL: url) {
//                cell.menuIconImage.image = UIImage(data: data)
//            }
//        }
        
        cell.menuIconImage.kf_setImageWithURL(NSURL(string:menu.menuIconURL)!, placeholderImage: nil)
        
        
//        let menuImage = UIImage(named: items[indexPath.row])
//        cell.menuIconImage.image = menuImage
        cell.menuName.text = menu.menuName
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //dispatch_async(dispatch_get_main_queue(),{
        
        
        
//        let transition = CATransition()
//        transition.duration = 0.3
//        //kCAMediaTimingFunctionEaseInEaseOut
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        self.view.window?.layer.addAnimation(transition,forKey:nil)
//        dispatch_async(dispatch_get_main_queue(),{
//            self.dismissViewControllerAnimated(false, completion: nil)
//        })
            //self.dismissViewControllerAnimated(true, completion: { () -> Void in
                if(indexPath.row == 9) {
                    for (var i = 0; i < self.navigationController?.viewControllers.count; i++) {
                        if(self.navigationController?.viewControllers[i].isKindOfClass(ViewController) == true) {
                            
                            self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! ViewController, animated: true)
                            
                            break;
                        }
                    }
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: "securityToken")
                } else {
                    print(self.navigationController?.viewControllers)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("listView")
                    self.navigationController?.pushViewController(vc, animated: true)
                }

//            }
//        )
        
       // })
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
    }
//
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        print("searchBar")
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
