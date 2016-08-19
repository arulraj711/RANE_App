//
//  CommonViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/17/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                           style: UIBarButtonItemStyle.Plain ,
                                           target: self, action: #selector(CommonViewController.OnMenuClicked))
        self.navigationItem.leftBarButtonItem = menu_button_
        
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        
        if(securityToken!.characters.count != 0){
            print(securityToken!.characters.count) // "Hello World"
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

        //self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc1 = storyboard.instantiateViewControllerWithIdentifier("listView")
//        
//        self.navigationController?.addChildViewController(vc1)
//        
//        let vc2 = storyboard.instantiateViewControllerWithIdentifier("menuView")
//        self.navigationController?.addChildViewController(vc2)
        
        
        
            
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
