//
//  CommonViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/17/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import PKRevealController

class CommonViewController: UIViewController,PKRevealing {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("common view didload")
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                           style: UIBarButtonItemStyle.Plain ,
                                           target: self, action: #selector(CommonViewController.OnMenuClicked))
        self.navigationItem.leftBarButtonItem = menu_button_
        self.switchRootViewBasedOnDevice()
//        if(NSUserDefaults.standardUserDefaults().stringForKey("securityToken") != nil) {
//            let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
//            if(securityToken!.characters.count != 0){
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
//                let vc1 = storyboard.instantiateViewControllerWithIdentifier("menuView")
//                let vc2 = storyboard.instantiateViewControllerWithIdentifier("listView")
//                var controllers = self.navigationController?.viewControllers;
//                controllers?.append(vc)
//                controllers?.append(vc1)
//                controllers?.append(vc2)
//                
//                self.navigationController?.setViewControllers(controllers!, animated: true)
//            } else {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
//                self.navigationController?.addChildViewController(vc)
//                
//            }
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
//            self.navigationController?.addChildViewController(vc)
//        }
        
    }
    override func viewDidAppear(animated: Bool) {
        print("common view did appear")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func switchRootViewBasedOnDevice() {
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            // It's an iPhone
            if(NSUserDefaults.standardUserDefaults().stringForKey("securityToken") != nil) {
                let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
                if(securityToken!.characters.count != 0){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                    let vc1 = storyboard.instantiateViewControllerWithIdentifier("menuView")
                    let vc2 = storyboard.instantiateViewControllerWithIdentifier("listView")
                    var controllers = self.navigationController?.viewControllers;
                    controllers?.append(vc)
                    controllers?.append(vc1)
                    controllers?.append(vc2)
                    self.navigationController?.setViewControllers(controllers!, animated: true)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                    self.navigationController?.addChildViewController(vc)
                    
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                self.navigationController?.addChildViewController(vc)
            }
            break
        case .Pad:
            // It's an iPad
            if(NSUserDefaults.standardUserDefaults().stringForKey("securityToken") != nil) {
                let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
                if(securityToken!.characters.count != 0){
                    let storyboard = UIStoryboard(name: "iPad-Design", bundle: nil)
                    let frontViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("listNavController") as! UINavigationController
                    let leftViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("iPadMenuView")
                    let revealController: PKRevealController = PKRevealController(frontViewController: frontViewController, leftViewController: leftViewController)
                    revealController.delegate = self
                    UIApplication.sharedApplication().keyWindow?.rootViewController = revealController;
                } else {
                    let storyboard = UIStoryboard(name: "iPad-Design", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                    self.navigationController?.addChildViewController(vc)
                }
            } else {
                let storyboard = UIStoryboard(name: "iPad-Design", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("loginView")
                self.navigationController?.addChildViewController(vc)
            }
            break
        case .Unspecified:
            break
        default:
            break
            // Uh, oh! What could it be?
        }
    }
    

    func OnMenuClicked() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
