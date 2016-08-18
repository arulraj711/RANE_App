//
//  ListViewController.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var listNavigationBarItem: UINavigationItem!
    @IBOutlet var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageName = "nav_logo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.navigationItem.titleView = imageView
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                       style: UIBarButtonItemStyle.Plain ,
                                       target: self, action: #selector(ListViewController.OnMenuClicked))
        self.navigationItem.leftBarButtonItem = menu_button_
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
    {
        let headerView:UIView = UIView()
        let label:UILabel = UILabel()
        let headerColorView:UIView = UIView()
        var imageViewObject :UIImageView
        if(section == 0) {
            headerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 72)
            label.frame = CGRectMake(20, 21, tableView.bounds.size.width-60, 52)
            headerColorView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 20)
            imageViewObject = UIImageView(frame:CGRectMake(tableView.bounds.size.width-27, 36, 8, 20));
            headerColorView.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 241/255, blue: 245/255, alpha: 1)
            label.text = "COMPANY NEWS"
            headerView.addSubview(headerColorView)
            imageViewObject.image = UIImage(named:"expandbutton")
            headerView.addSubview(imageViewObject)
        } else if(section == 1) {
            headerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 52)
            label.frame = CGRectMake(20, 0, tableView.bounds.size.width-60, 52)
            imageViewObject = UIImageView(frame:CGRectMake(tableView.bounds.size.width-27, 16, 8, 20));
            label.text = "INDUSTRY NEWS"
            imageViewObject.image = UIImage(named:"expandbutton")
            headerView.addSubview(imageViewObject)
        }
        headerView.backgroundColor = UIColor.whiteColor()
        label.font = UIFont(name:"OpenSans-Semibold", size: 14)
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 72.0
        } else {
            return 52.0
        }
        
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    
    func OnMenuClicked() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
//        let <#name#> = <#value#>
//        
//        
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        for (UIViewController *aViewController in allViewControllers) {
//            if ([aViewController isKindOfClass:[RequiredViewController class]]) {
//                [self.navigationController popToViewController:aViewController animated:NO];
//            }
//        }
        
//        for (var i = 0; i < self.navigationController?.viewControllers.count; i++) {
//            if(self.navigationController?.viewControllers[i].isKindOfClass(MenuViewController) == true) {
//                
//                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! MenuViewController, animated: true)
//                
//                break;
//            }
//        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc1 = storyboard.instantiateViewControllerWithIdentifier("menuView")
//        self.navigationController?.showViewController(vc1, sender: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("menuView")
//        
//        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        
//        self.view.window?.layer.addAnimation(transition,forKey:nil)
//        self.presentViewController(vc, animated: false, completion: nil)
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
