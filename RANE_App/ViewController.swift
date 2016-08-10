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

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var testImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.outerView.layer.masksToBounds = true;
        self.outerView.layer.cornerRadius = 6.0;
        
        //WebService().mySimpleFunction()
       // WebService().loginWebServiceCall()
        
        let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
        
        WebService().loginWebService("userauthentication", parameters: dictionary)
        
        
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true;
    }
}

