

//
//  DetailViewController.swift
//  RANE_App
//
//  Created by cape start on 23/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,MFMailComposeViewControllerDelegate {
    var articleArray = [ArticleObject]()
    @IBOutlet var collectionView: UICollectionView!
     @IBOutlet var readFullArticleButton: UIButton!
    var outletWithContactString:String = ""
    var currentindex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        readFullArticleButton.layer.masksToBounds = true;
        readFullArticleButton.layer.cornerRadius = 6.0;
        
        
        self.collectionView.dataSource = nil;
        self.collectionView.delegate = nil;
        
        

        
        
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.reloadData()
        print("current index",currentindex!)
        self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: currentindex!, inSection: 0), atScrollPosition: .Right, animated: false)

    }
    
    func reloadNavBarItems(artilceObj:ArticleObject) {
        
        var selectedArticleDictionary = Dictionary<String, String>()
        selectedArticleDictionary["title"] = artilceObj.articleTitle
        selectedArticleDictionary["Description"] = artilceObj.articleDescription
        
        NSUserDefaults.standardUserDefaults().setObject(selectedArticleDictionary, forKey: "SelectedArticleDictionary")
        
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
        mailButton.addTarget(self, action: #selector(DetailViewController.mailButtonClick), forControlEvents: .TouchUpInside)
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
        savedForLaterButton.setImage(UIImage(named: "markedimportant_icon"), forState: .Selected)
        savedForLaterButton.frame = CGRectMake(0, 0, 30, 30)
        //        savedForLaterButton.backgroundColor = UIColor.redColor()
        //btn4.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let savedForLaterItem = UIBarButtonItem()
        savedForLaterItem.customView = savedForLaterButton
        if(artilceObj.isSavedForLater == 1) {
            savedForLaterButton.selected = true
        } else {
            savedForLaterButton.selected = false
        }
        
        
        
        let markedImportantButton = UIButton()
        markedImportantButton.setImage(UIImage(named: "markedimportant_icon"), forState: .Normal)
        markedImportantButton.setImage(UIImage(named: "bookmark-icon"), forState: .Selected)
        markedImportantButton.frame = CGRectMake(0, 0, 30, 30)
        //        markedImportantButton.backgroundColor = UIColor.redColor()
        // btn5.addTarget(self, action: Selector("action2:"), forControlEvents: .TouchUpInside)
        let markedImportantItem = UIBarButtonItem()
        markedImportantItem.customView = markedImportantButton
        if(artilceObj.isMarkedImportant == 1) {
            markedImportantButton.selected = true
        } else {
            markedImportantButton.selected = false
        }
        
//         NSUserDefaults.standardUserDefaults().setObject(artilceObj, forKey: "articleObject")
        
        self.navigationItem.rightBarButtonItems = [markedImportantItem,savedForLaterItem,folderItem,mailItem,chatItem]
    }
    
    func mailButtonClick() {
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
            print("notification info",info)
            
            let mailComposeViewController = configuredMailComposeViewController("arul.raj@capestart.com", title: info["title"]!, description: info["Description"]!)
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
    }
    
    func configuredMailComposeViewController(toAddress:String,title:String,description:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([toAddress])
        mailComposerVC.setSubject(title)
        mailComposerVC.setMessageBody(description, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return articleArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DetailViewCell
        //cell.scrollView.contentOffset = CGPointMake(0, 0)
        let articleObject:ArticleObject = articleArray[indexPath.row]
        dispatch_async(dispatch_get_main_queue(),{
            self.reloadNavBarItems(articleObject)
        })
        
        if(articleObject.fieldsName.characters.count == 0) {
            cell.fieldsNameHeightConstraint.constant = 0;
        } else {
            cell.fieldsNameHeightConstraint.constant = 21;
            cell.articleFieldNamelabel.text = articleObject.fieldsName
        }
        cell.webviewHeightConstraint.constant = 20
        cell.articleTitleLabel.text = articleObject.articleTitle
        
        self.outletWithContactString = articleObject.outletName+" | "+articleObject.contactName
        
        cell.articleContactLabel.text = outletWithContactString
        let dateString:String = Utils.convertTimeStampToDrillDateModel(articleObject.articlepublishedDate)
        cell.articlePublishedDateLabel.text = "Published: "+dateString
        //        print("before removing",self.articleDetailDescription)
        //        let removedLinkString = self.articleDetailDescription.stringByReplacingOccurrencesOfString("<span style=\"color:#000080\">Click here to read full article</span>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //        print("after removing".removedLinkString)
        let aStr = String(format: "<body style='color:#777777;font-family:Open Sans;line-height: auto;font-size: 14px;padding:0px;margin:0;'>%@", articleObject.articleDetailedDescription)
        
        //        htmlString = [NSString stringWithFormat:@"<body style='color:#000000;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
        
        cell.articleDetailWebView.loadHTMLString(aStr, baseURL: nil)

    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("flow layout delegate",self.view.frame.size.width,self.view.frame.size.height)
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
        
    }
    
    @IBAction func readFullArticleButtonClick(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:ReadFullArticleViewController = storyboard.instantiateViewControllerWithIdentifier("readFullArticleView") as! ReadFullArticleViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
