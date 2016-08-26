

//
//  DetailViewController.swift
//  RANE_App
//
//  Created by cape start on 23/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyJSON

protocol DetailViewControllerDelegate {
    func controller(controller: DetailViewController, articleArray:[ArticleObject])
}

class DetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,MFMailComposeViewControllerDelegate {
    var delegate: DetailViewControllerDelegate?
    var articleArray = [ArticleObject]()
    var activityTypeId:Int = 0
    var searchKeyword:String = ""
    var contentTypeId:Int = 0
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
        
        //handle session expired
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(handleSessionExpired),
            name: "SessionExpired",
            object: nil)
        
        
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let isFromListPage = NSUserDefaults.standardUserDefaults().boolForKey("fromListPage")
        if(isFromListPage) {
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
            self.collectionView.reloadData()
            print("current index",currentindex!)
            self.collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: currentindex!, inSection: 0), atScrollPosition: .Right, animated: false)
        }
    }
    
    func handleSessionExpired(notification: NSNotification) {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "securityToken")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func reloadNavBarItems(artilceObj:ArticleObject) {
        
        var selectedArticleDictionary = Dictionary<String, String>()
        selectedArticleDictionary["title"] = artilceObj.articleTitle
        selectedArticleDictionary["Description"] = artilceObj.articleDescription
        selectedArticleDictionary["ArticleURL"] = artilceObj.articleURL
        selectedArticleDictionary["ArticleId"] = artilceObj.articleId
        selectedArticleDictionary["isMarked"] = String(artilceObj.isMarkedImportant)
        selectedArticleDictionary["isSaved"] = String(artilceObj.isSavedForLater)
        
        
        NSUserDefaults.standardUserDefaults().setObject(selectedArticleDictionary, forKey: "SelectedArticleDictionary")
        
        let chatButton = UIButton()
        chatButton.setImage(UIImage(named: "chat_icon"), forState: .Normal)
        chatButton.frame = CGRectMake(0, 0, 28, 28)
        chatButton.addTarget(self, action: #selector(DetailViewController.commentsButtonClick), forControlEvents: .TouchUpInside)
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
        savedForLaterButton.setImage(UIImage(named: "bookmarkFilled-icon"), forState: .Selected)
        savedForLaterButton.frame = CGRectMake(0, 0, 30, 30)
        savedForLaterButton.addTarget(self, action: #selector(DetailViewController.savedForLaterButtonClick), forControlEvents: .TouchUpInside)
        let savedForLaterItem = UIBarButtonItem()
        savedForLaterItem.customView = savedForLaterButton
        if(artilceObj.isSavedForLater == 1) {
            savedForLaterButton.selected = true
        } else {
            savedForLaterButton.selected = false
        }
        
        
        
        let markedImportantButton = UIButton()
        markedImportantButton.setImage(UIImage(named: "markedimportant_icon"), forState: .Normal)
        markedImportantButton.setImage(UIImage(named: "markedimportantFilled_icon"), forState: .Selected)
        markedImportantButton.frame = CGRectMake(0, 0, 30, 30)
        markedImportantButton.addTarget(self, action: #selector(DetailViewController.markedImportantButtonClick), forControlEvents: .TouchUpInside)
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
    
    func commentsButtonClick() {
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "fromListPage")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:CommentsViewController = storyboard.instantiateViewControllerWithIdentifier("commentsView") as! CommentsViewController
            print("selected article id",info["ArticleId"]!)
            vc.articleId = info["ArticleId"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func markedImportantButtonClick() {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
                let userActivitiesInputDictionary: NSMutableDictionary = NSMutableDictionary()
                userActivitiesInputDictionary.setValue("2", forKey: "status")
                userActivitiesInputDictionary.setValue(info["ArticleId"], forKey: "selectedArticleId")
                userActivitiesInputDictionary.setValue(securityToken, forKey: "securityToken")
                if(info["isMarked"] == "1") {
                    userActivitiesInputDictionary.setValue(false, forKey: "isSelected")
                } else if(info["isMarked"] == "0") {
                    userActivitiesInputDictionary.setValue(true, forKey: "isSelected")
                }
                WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        var dataDict = Dictionary<String, String>()
                        dataDict["articleId"] = info["articleId"]
                        dataDict["isMarked"] = info["isMarked"]
                        NSNotificationCenter.defaultCenter().postNotificationName("updateMarkedImportantStatus", object:self, userInfo:dataDict)
                        
                        for article in self.articleArray {
                            if(article.articleId == info["ArticleId"]) {
                                if(info["isMarked"] == "1") {
                                    article.isMarkedImportant = 0
                                } else if(info["isMarked"] == "0"){
                                    article.isMarkedImportant = 1
                                }
                                self.reloadNavBarItems(article)
                            } else {
                                continue
                            }
                        }
                        
                    })
                    
                    
                }
            }
        }
        
    }
    
    func savedForLaterButtonClick() {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
                let userActivitiesInputDictionary: NSMutableDictionary = NSMutableDictionary()
                userActivitiesInputDictionary.setValue("3", forKey: "status")
                userActivitiesInputDictionary.setValue(info["ArticleId"], forKey: "selectedArticleId")
                userActivitiesInputDictionary.setValue(securityToken, forKey: "securityToken")
                if(info["isSaved"] == "1") {
                    userActivitiesInputDictionary.setValue(false, forKey: "isSelected")
                } else if(info["isSaved"] == "0") {
                    userActivitiesInputDictionary.setValue(true, forKey: "isSelected")
                }
                WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        var dataDict = Dictionary<String, String>()
                        dataDict["articleId"] = info["articleId"]
                        dataDict["isSaved"] = info["isSaved"]
                        NSNotificationCenter.defaultCenter().postNotificationName("updateSavedForLaterStatus", object:self, userInfo:dataDict)
                        
                        for article in self.articleArray {
                            if(article.articleId == info["ArticleId"]) {
                                if(info["isSaved"] == "1") {
                                    article.isSavedForLater = 0
                                } else if(info["isSaved"] == "0"){
                                    article.isSavedForLater = 1
                                }
                                self.reloadNavBarItems(article)
                            } else {
                                continue
                            }
                        }
                        
                        
                    })
                    
                    
                }
            }
        }
    }
    
    func mailButtonClick() {
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
            print("notification info",info)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "fromListPage")
            let mailComposeViewController = configuredMailComposeViewController((NSUserDefaults.standardUserDefaults().objectForKey("email")?.stringValue)!, title: info["title"]!, description: info["Description"]!)
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
                print("before removing",articleObject.articleDetailedDescription)
                let removedStyleTagString = articleObject.articleDetailedDescription.stringByReplacingOccurrencesOfString("style", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                print("after removing",removedStyleTagString)
                let removeClickText = removedStyleTagString.stringByReplacingOccurrencesOfString("Click here to read full article", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let aStr = String(format: "<body style='color:#777777;font-family:Open Sans;line-height: auto;font-size: 14px;padding:0px;margin:0;'>%@", removeClickText)
        
        //        htmlString = [NSString stringWithFormat:@"<body style='color:#000000;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
        
        cell.articleDetailWebView.loadHTMLString(aStr, baseURL: nil)

    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print("flow layout delegate",self.view.frame.size.width,self.view.frame.size.height)
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
        
        
    }
    
    @IBAction func readFullArticleButtonClick(sender: UIButton) {
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "fromListPage")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:ReadFullArticleViewController = storyboard.instantiateViewControllerWithIdentifier("readFullArticleView") as! ReadFullArticleViewController
            vc.articleUrl = info["ArticleURL"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollOffset:CGFloat = self.collectionView.contentOffset.x
        var pageNo:Int?
        let mod:Int = self.articleArray.count%10
        let lastCount:Int = self.articleArray.count-1
        print("scroll offset",scrollOffset)
        print("collection width",self.collectionView.frame.size.width*CGFloat(lastCount))
        if(scrollOffset > self.collectionView.frame.size.width*CGFloat(lastCount)) {
            if(self.articleArray.count != 0) {
                if (mod == 0) {
                    pageNo  = self.articleArray.count/10;
                    
                } else {
                    let defaultValue:Int = 10-mod;
                    pageNo  = (self.articleArray.count+defaultValue)/10;
                    
                }
                print("api call")
                
                if(self.searchKeyword.characters.count == 0) {
                    if(self.contentTypeId == 20) {
                        //for daily digest
                        self.dailyDigestAPICall(pageNo!)
                    } else {
                        //for normal article list
                        self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
                    }
                } else {
                    self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
                }
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let cell:DetailViewCell = self.collectionView.cellForItemAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>)
//        DetailViewCell *cell = (CorporateDetailCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
//        // [cell resetCellWebviewHeight];
//        [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
    
    
    
    func dailyDigestAPICall(pageNo:Int) {
        var nextSetOfArticles = [ArticleObject]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callDailyDigestArticleListWebService(0, securityToken: securityToken!, page: pageNo, size: 10){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        for entry in results {
                            self.articleArray.append(ArticleObject(json: entry))
                            nextSetOfArticles.append(ArticleObject(json: entry))
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            self.collectionView.reloadData()
                            if let delegate = self.delegate {
                                delegate.controller(self, articleArray: nextSetOfArticles)
                            }
//                            NSNotificationCenter.defaultCenter().postNotificationName("SavedForLaterButtonClick", object:self, userInfo:nextSetOfArticles as ArticleObject)
                        })
                        
                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "No more articles to display")
                        })
                    }
                    
                } else {
                    
                }
            }
        }
        
    }
    
    
    func articleAPICall(activityTypeId:Int,contentTypeId:Int,pagenNo:Int,searchString:String) {
        var nextSetOfArticles = [ArticleObject]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callArticleListWebService(activityTypeId, securityToken: securityToken!, contentTypeId: contentTypeId, page: pagenNo, size: 10,searchString: searchString){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        for entry in results {
                            self.articleArray.append(ArticleObject(json: entry))
                            nextSetOfArticles.append(ArticleObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            self.collectionView.reloadData()
                            if let delegate = self.delegate {
                                delegate.controller(self, articleArray: nextSetOfArticles)
                            }
                        })
                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "No more articles to display")
                        })
                    }
                    
                } else {
                    
                }
            }
            
        }
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
