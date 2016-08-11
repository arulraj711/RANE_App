//
//  ViewController.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/4/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
//import WebService

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        loginButton.layer.masksToBounds = true;
        loginButton.layer.cornerRadius = 6.0;
        
        userInfoView.layer.masksToBounds = true;
        userInfoView.layer.cornerRadius = 6.0;
        userInfoView.layer.borderColor = UIColor.lightGrayColor().CGColor;
        userInfoView.layer.borderWidth = 1;
        
        //let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
        
       // WebService().loginWebService("userauthentication", parameters: dictionary)
        
        
//        print(logoImage.frame.size.width)
//        print(logoImage.frame.size.height)
//        
//        if let url = NSURL(string: "https://s3.amazonaws.com/ranecloudwp/blog/wp-content/uploads/2016/06/09191314/rane_horz-1-2.png") {
//            if let data = NSData(contentsOfURL: url) {
//                logoImage.image = UIImage(data: data)
//            }        
//        }
        
        
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
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
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

