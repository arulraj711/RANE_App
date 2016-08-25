//
//  DetailViewCell.swift
//  RANE_App
//
//  Created by cape start on 24/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    @IBOutlet var fieldsNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet var webviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var articlePublishedDateLabel: UILabel!
    @IBOutlet var articleDetailWebView: UIWebView!
    @IBOutlet var articleContactLabel: UILabel!
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var articleFieldNamelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let myFirstLabel = UILabel()
//        let myFirstButton = UIButton()
//        myFirstLabel.text = "I made a label on the screen #toogood4you"
//        myFirstLabel.font = UIFont(name: "MarkerFelt-Thin", size: 45)
//        myFirstLabel.textColor = UIColor.redColor()
//        myFirstLabel.textAlignment = .Center
//        myFirstLabel.numberOfLines = 5
//        myFirstLabel.frame = CGRectMake(15, 54, 300, 500)
//        myFirstButton.setTitle("✸", forState: .Normal)
//        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
//        myFirstButton.frame = CGRectMake(15, -50, 300, 500)
//        myFirstButton.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
//        self.addSubview(myFirstLabel)
//        self.addSubview(myFirstButton)
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        
//        
//        let readFullArticleButton = UIButton()
//        readFullArticleButton.setTitle("READ FULL ARTICLE", forState: .Normal)
//        readFullArticleButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
//        //readFullArticleButton.titleLabel!.font =  UIFont(name: YourfontName, size: 20)
//        print("y value",screenSize.height-20-20-40,screenSize.height,screenSize.width)
//        print("width value",screenSize.width-20-20,self.superview)
//        readFullArticleButton.frame = CGRectMake(20,screenSize.height-20-20-20-50, screenSize.width-20-20, 50)
//        self.addSubview(readFullArticleButton)
    }
    
    func webViewDidStartLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("AA")
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        print("BB")
        webView.scrollView.scrollEnabled = false;
        webView.scrollView.bounces = false;
        let frame:CGRect = webView.frame
        var newBounds:CGRect = self.articleDetailWebView.bounds
        newBounds.size.height =  self.articleDetailWebView.scrollView.contentSize.height
        let pointOfWebview:CGFloat = newBounds.size.height
        print("webview height",pointOfWebview)
        print("webview y position",webView.frame.origin.y)
        self.webviewHeightConstraint.constant = pointOfWebview
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,pointOfWebview+webView.frame.origin.y+64)
    }
    
}
