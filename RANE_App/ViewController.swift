//
//  ViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/4/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import PKRevealController

class ViewController: UIViewController,PKRevealing {
    
    @IBOutlet var emailAddressField: UITextField!
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var testImage: UIImageView!
    //var menuItems = [MenuObject]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        loginButton.layer.masksToBounds = true;
        loginButton.layer.cornerRadius = 6.0;
        
        
        
        userInfoView.layer.masksToBounds = true;
        userInfoView.layer.cornerRadius = 6.0;
        userInfoView.layer.borderColor = UIColor.init(colorLiteralRed: 199/255, green: 199/255, blue: 205/255, alpha: 1).CGColor;
        userInfoView.layer.borderWidth = 1;
//  
        emailAddressField.text = "rane.demo@ranenetwork.com"
        passwordField.text = "ranestart"
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false;
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    //Key board actions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == emailAddressField) {
            passwordField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            
        }
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 120
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 120
            }
            else {
                
            }
        }
    }
    
    @IBAction func loginButtonCick(sender: UIButton) {
        
        self.emailAddressField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        let loginInputDictionary: NSMutableDictionary = NSMutableDictionary()
        loginInputDictionary.setValue(emailAddressField.text, forKey: "email")
        loginInputDictionary.setValue(passwordField.text, forKey: "password")
        
        WebServiceManager.sharedInstance.callLoginWebService(loginInputDictionary) { (json:JSON) in
            print("login response-->",json);
            NSUserDefaults.standardUserDefaults().setObject(json["securityToken"].stringValue, forKey: "securityToken")
            NSUserDefaults.standardUserDefaults().setObject(json["company"]["id"].intValue, forKey: "companyId")
            NSUserDefaults.standardUserDefaults().setObject(json["id"].intValue, forKey: "userId")
            //NSUserDefaults.standardUserDefaults().setObject(json["company"]["id"].intValue, forKey: "companyId")
            NSUserDefaults.standardUserDefaults().setObject(json["email"].stringValue, forKey: "email")
            
            dispatch_async(dispatch_get_main_queue(),{
                WebServiceManager.sharedInstance.callContentCategoriesService(NSUserDefaults.standardUserDefaults().integerForKey("companyId"), securityToken: NSUserDefaults.standardUserDefaults().stringForKey("securityToken")!) { (json:JSON) in
                    print("content category JSON",json)
                }
                if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
                    //code for iPhone
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("menuView")
                    let vc1 = storyboard.instantiateViewControllerWithIdentifier("listView")
                    var controllers = self.navigationController?.viewControllers;
                    controllers?.append(vc)
                    controllers?.append(vc1)
                    self.navigationController?.setViewControllers(controllers!, animated: true)
                } else if(UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
                    //code for iPad
                    let storyboard = UIStoryboard(name: "iPad-Design", bundle: nil)
                    let frontViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("listNavController") as! UINavigationController
                    let leftViewController: UIViewController = storyboard.instantiateViewControllerWithIdentifier("iPadMenuView")
                    let revealController: PKRevealController = PKRevealController(frontViewController: frontViewController, leftViewController: leftViewController)
                    revealController.delegate = self
                    UIApplication.sharedApplication().keyWindow?.rootViewController = revealController;
                }
            })
            
        }
    }
    
    
    
    
    
    @IBAction func forgotPasswordButtonClick(sender: UIButton) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc:ReadFullArticleViewController = storyboard.instantiateViewControllerWithIdentifier("readFullArticleView") as! ReadFullArticleViewController
                vc.articleUrl = "https://ranenetwork.com/app/cms/users/password/new"
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /* Code for draw path over the view
    func configureEmailField(textfield: UITextField) {
        let path = UIBezierPath(roundedRect:textfield.bounds, byRoundingCorners:[.TopLeft, .TopRight], cornerRadii: CGSizeMake(10, 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        textfield.layer.mask = maskLayer
       
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

