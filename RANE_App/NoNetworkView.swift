//
//  NoNetworkView.swift
//  RANE_App
//
//  Created by cape start on 01/09/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class NoNetworkView: UIView {
    @IBAction func retryButtonClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("RetryButtonClick", object:self, userInfo:nil)
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "NoNetworkView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
