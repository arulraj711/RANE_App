//
//  ViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/4/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
//import WebService
import SwiftyJSON
class ViewController: UIViewController {
    @IBOutlet var emailAddressField: UITextField!
   
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var testImage: UIImageView!
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
        
        //let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
        
        //WebService().loginWebService("userauthentication", parameters: dictionary)
        
        
//        let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
//        WebServiceManager().loginWebServiceManager(dictionary)
        
        emailAddressField.text = "kavin.xavier@capestart.com"
        passwordField.text = "start"
        
        
        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("securityToken") {
            print(myLoadedString) // "Hello World"
            dispatch_async(dispatch_get_main_queue(),{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("listView")
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
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
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            print("keyboard show height",keyboardSize.height)
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 120
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            print("keyboard hide height",keyboardSize.height)
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 120
            }
            else {
                
            }
        }
    }
    
    @IBAction func loginButtonCick(sender: UIButton) {
        
        
        let loginInputDictionary: NSMutableDictionary = NSMutableDictionary()
        loginInputDictionary.setValue(emailAddressField.text, forKey: "email")
        loginInputDictionary.setValue(passwordField.text, forKey: "password")
        
        WebServiceManager.sharedInstance.getRandomUser(loginInputDictionary) { (json:JSON) in
           
            NSUserDefaults.standardUserDefaults().setObject(json["securityToken"].stringValue, forKey: "securityToken")
            dispatch_async(dispatch_get_main_queue(),{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("listView")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
        }
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

