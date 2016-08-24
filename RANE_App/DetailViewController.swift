//
//  DetailViewController.swift
//  RANE_App
//
//  Created by cape start on 23/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    var articleFieldName:String = ""
    var articleTitle:String = ""
    var articleContact:String = ""
    var articleOutlet:String = ""
    var articlePublishedDate:String = ""
    var articleDetailDescription:String = ""
    var outletWithContactString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        readFullArticleButton.layer.masksToBounds = true;
//        readFullArticleButton.layer.cornerRadius = 6.0;
        
        let chatButton = UIButton()
        chatButton.setImage(UIImage(named: "chat_icon"), forState: .Normal)
        chatButton.frame = CGRectMake(0, 0, 28, 28)
//        chatButton.backgroundColor = UIColor.redColor()
       // btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        let chatItem = UIBarButtonItem()
        chatItem.customView = chatButton
        
        let mailButton = UIButton()
        mailButton.setImage(UIImage(named: "mail_icon"), forState: .Normal)
        mailButton.frame = CGRectMake(0, 0, 28, 28)
//        mailButton.backgroundColor = UIColor.redColor()
       // btn2.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let mailItem = UIBarButtonItem()
        mailItem.customView = mailButton
        
        
        let folderButton = UIButton()
        folderButton.setImage(UIImage(named: "folder_icon"), forState: .Normal)
        folderButton.frame = CGRectMake(0, 0, 30, 30)
//        folderButton.backgroundColor = UIColor.redColor()
       // btn3.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let folderItem = UIBarButtonItem()
        folderItem.customView = folderButton
        
        let savedForLaterButton = UIButton()
        savedForLaterButton.setImage(UIImage(named: "bookmark-icon"), forState: .Normal)
        savedForLaterButton.frame = CGRectMake(0, 0, 30, 30)
//        savedForLaterButton.backgroundColor = UIColor.redColor()
        //btn4.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let savedForLaterItem = UIBarButtonItem()
        savedForLaterItem.customView = savedForLaterButton
        
        let markedImportantButton = UIButton()
        markedImportantButton.setImage(UIImage(named: "markedimportant_icon"), forState: .Normal)
        markedImportantButton.frame = CGRectMake(0, 0, 30, 30)
//        markedImportantButton.backgroundColor = UIColor.redColor()
       // btn5.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let markedImportantItem = UIBarButtonItem()
        markedImportantItem.customView = markedImportantButton
        
        self.navigationItem.rightBarButtonItems = [markedImportantItem,savedForLaterItem,folderItem,mailItem,chatItem]
        
        self.updateDetailView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DetailViewCell
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("flow layout delegate")
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
        
    }
    
//    - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    float cellWidth = (self.view.frame.size.width / 2) - 35;
//    float cellHeight = cellWidth * 190.0f / 270.0f;
//    return CGSizeMake(cellWidth, cellHeight);
//    }
    
    func updateDetailView() {
        
//        if(self.articleFieldName.characters.count == 0) {
//            self.fieldsNameHeightConstraint.constant = 0;
//        } else {
//            self.fieldsNameHeightConstraint.constant = 21;
//            self.articleFieldNamelabel.text = self.articleFieldName
//        }
//        
//        self.articleTitleLabel.text = self.articleTitle
//        
//        self.outletWithContactString = self.articleOutlet+" | "+self.articleContact
//        
//        self.articleContactLabel.text = outletWithContactString
//        self.articlePublishedDateLabel.text = "Published: "+self.articlePublishedDate
////        print("before removing",self.articleDetailDescription)
////        let removedLinkString = self.articleDetailDescription.stringByReplacingOccurrencesOfString("<span style=\"color:#000080\">Click here to read full article</span>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
////        print("after removing".removedLinkString)
//        let aStr = String(format: "<body style='color:#777777;font-family:Open Sans;line-height: auto;font-size: 14px;padding:0px;margin:0;'>%@", self.articleDetailDescription)
//        
////        htmlString = [NSString stringWithFormat:@"<body style='color:#000000;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
//        
//        self.articleDetailWebView.loadHTMLString(aStr, baseURL: nil)
    }

    func webViewDidStartLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        print("AA")
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        print("BB")
//        webView.scrollView.scrollEnabled = false;
//        webView.scrollView.bounces = false;
//        let frame:CGRect = webView.frame
//        var newBounds:CGRect = self.articleDetailWebView.bounds
//        newBounds.size.height =  self.articleDetailWebView.scrollView.contentSize.height
//        let pointOfWebview:CGFloat = newBounds.size.height
//        print("webview height",pointOfWebview)
//        print("webview y position",webView.frame.origin.y)
//        self.webviewHeightConstraint.constant = pointOfWebview
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,pointOfWebview+webView.frame.origin.y)
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
