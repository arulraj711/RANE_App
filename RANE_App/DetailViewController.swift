

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
    func controller(controller: DetailViewController,contentType:Int ,articleArray:[Article])
}

class DetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,MFMailComposeViewControllerDelegate {
    var delegate: DetailViewControllerDelegate?
    var articleArray = [Article]()
    var activityTypeId:Int = 0
    var searchKeyword:String = ""
    var contentTypeId:Int = 0
    var dailyDigestId:Int = 0
    var isFromDailyDigest:Bool = true
    @IBOutlet var collectionView: UICollectionView!
     @IBOutlet var readFullArticleButton: UIButton!
    var outletWithContactString:String = ""
    var currentindex:Int?
    var currentIndexPath:Int?
    var selectedIndexPath:NSIndexPath?
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
        CoreDataController().deleteAndResetStack()
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "securityToken")
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else if(UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let frontViewController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("iPhoneRootView") as! UINavigationController
            UIApplication.sharedApplication().keyWindow?.rootViewController = frontViewController;
        }
    }
    
    func reloadNavBarItems(artilceObj:Article) {
        
        var selectedArticleDictionary = Dictionary<String, String>()
        selectedArticleDictionary["title"] = artilceObj.articleTitle
        selectedArticleDictionary["Description"] = artilceObj.articleDescription
        selectedArticleDictionary["ArticleURL"] = artilceObj.articleURL
        selectedArticleDictionary["ArticleId"] = artilceObj.articleId
        selectedArticleDictionary["isMarked"] = String(artilceObj.isMarkedImportant)
        selectedArticleDictionary["isSaved"] = String(artilceObj.isSavedForLater)
        selectedArticleDictionary["markAsImportantUserId"] = String(artilceObj.markAsImportantUserId)
        selectedArticleDictionary["markAsImportantUserName"] = String(artilceObj.markAsImportantUserName)
        
        
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
        folderButton.addTarget(self, action: #selector(DetailViewController.folderButtonClick), forControlEvents: .TouchUpInside)
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
    
    func folderButtonClick() {
        if let info = NSUserDefaults.standardUserDefaults().objectForKey("SelectedArticleDictionary") as? Dictionary<String,String> {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "fromListPage")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc:FolderViewController = storyboard.instantiateViewControllerWithIdentifier("folderView") as! FolderViewController
            print("selected article id",info["ArticleId"]!)
            vc.selectedArticleId = info["ArticleId"]!
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
                let markAsImportantUserId = info["markAsImportantUserId"]!
                let markAsImportantUserName = info["markAsImportantUserName"]!
                let loginUserId:Int = NSUserDefaults.standardUserDefaults().integerForKey("userId")
                if(info["isMarked"] == "1") {
                    if(markAsImportantUserId == "-1") {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "A FullIntel analyst marked this as important. If you like to change, please request via Feedback")
                        })
                    } else if(markAsImportantUserId == String(loginUserId)) {
                        
//                        if(self.contentTypeId == 9) {
//                            let appDelegate =
//                                UIApplication.sharedApplication().delegate as! AppDelegate
//                            let managedContext = appDelegate.managedObjectContext
//                            do {
//                                print("indexpath",self.currentIndexPath!)
//                                print("article",self.articleArray[self.currentIndexPath!])
//                                managedContext.deleteObject(self.articleArray[self.currentIndexPath!] as Article)
//                                try managedContext.save()
//                                 dispatch_async(dispatch_get_main_queue(),{
//                                    self.collectionView.reloadData()
//                                })
//                            } catch {
//                                
//                            }
//                            
//                            
//                        }

                        
                        userActivitiesInputDictionary.setValue(false, forKey: "isSelected")
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            var dataDict = Dictionary<String, String>()
                            dataDict["articleId"] = info["articleId"]
                            dataDict["isMarked"] = info["isMarked"]
                            NSNotificationCenter.defaultCenter().postNotificationName("updateMarkedImportantStatus", object:self, userInfo:dataDict)
                            
                        })
                        
                        WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                            dispatch_async(dispatch_get_main_queue(),{
                                
                                for article in self.articleArray {
                                    if(article.articleId == info["ArticleId"]) {
                                        if(info["isMarked"] == "1") {
                                            //                                    article.isMarkedImportant = 0
                                            if(self.isFromDailyDigest) {
                                                CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!,contentTypeId: self.dailyDigestId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                            } else {
                                                CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!,contentTypeId: self.contentTypeId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                            }
                                            
                                        } else if(info["isMarked"] == "0"){
                                            //                                    article.isMarkedImportant = 1
                                            if(self.isFromDailyDigest) {
                                                CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!, contentTypeId: self.dailyDigestId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                            } else {
                                                CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!, contentTypeId: self.contentTypeId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                            }
                                            
                                            
                                        }
                                        self.reloadNavBarItems(article)
                                    } else {
                                        continue
                                    }
                                }
                                
                            })
                            
                            
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "If you like to change, please contact "+markAsImportantUserName+". who marked this article as important")
                        })
                    }
                    
                } else if(info["isMarked"] == "0") {
                    userActivitiesInputDictionary.setValue(true, forKey: "isSelected")
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        var dataDict = Dictionary<String, String>()
                        dataDict["articleId"] = info["articleId"]
                        dataDict["isMarked"] = info["isMarked"]
                        NSNotificationCenter.defaultCenter().postNotificationName("updateMarkedImportantStatus", object:self, userInfo:dataDict)
                        
                    })
                    
                    WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            for article in self.articleArray {
                                if(article.articleId == info["ArticleId"]) {
                                    if(info["isMarked"] == "1") {
                                        //                                    article.isMarkedImportant = 0
                                        if(self.isFromDailyDigest) {
                                            CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!,contentTypeId: self.dailyDigestId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                        } else {
                                            CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!,contentTypeId: self.contentTypeId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                        }
                                        
                                    } else if(info["isMarked"] == "0"){
                                        //                                    article.isMarkedImportant = 1
                                        if(self.isFromDailyDigest) {
                                            CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!, contentTypeId: self.dailyDigestId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                        } else {
                                            CoreDataController().updateMarkedImportantStatusInArticle(info["ArticleId"]!, contentTypeId: self.contentTypeId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                                        }
                                        
                                        
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
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    var dataDict = Dictionary<String, String>()
                    dataDict["articleId"] = info["articleId"]
                    dataDict["isSaved"] = info["isSaved"]
                    NSNotificationCenter.defaultCenter().postNotificationName("updateSavedForLaterStatus", object:self, userInfo:dataDict)
                })
                
                WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                    dispatch_async(dispatch_get_main_queue(),{
                        for article in self.articleArray {
                            if(article.articleId == info["ArticleId"]) {
                                if(info["isSaved"] == "1") {
//                                    article.isSavedForLater = 0
                                    if(self.isFromDailyDigest) {
                                        CoreDataController().updateSavedForLaterStatusInArticle(info["ArticleId"]!, contentTypeId: self.dailyDigestId,isSaved: 0,isSavedSync: Reachability.isConnectedToNetwork())
                                    } else {
                                        CoreDataController().updateSavedForLaterStatusInArticle(info["ArticleId"]!, contentTypeId: self.contentTypeId,isSaved: 0,isSavedSync: Reachability.isConnectedToNetwork())
                                    }
                                    
                                } else if(info["isSaved"] == "0"){
//                                    article.isSavedForLater = 1
                                    if(self.isFromDailyDigest) {
                                        CoreDataController().updateSavedForLaterStatusInArticle(info["ArticleId"]!, contentTypeId: self.dailyDigestId,isSaved: 1,isSavedSync: Reachability.isConnectedToNetwork())
                                    } else {
                                        CoreDataController().updateSavedForLaterStatusInArticle(info["ArticleId"]!, contentTypeId: self.contentTypeId,isSaved: 1,isSavedSync: Reachability.isConnectedToNetwork())
                                    }
                                    
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
            let mailComposeViewController = configuredMailComposeViewController(NSUserDefaults.standardUserDefaults().stringForKey("email")!, title: info["title"]!, description: info["Description"]!)
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
        let articleObject:Article = articleArray[indexPath.row]
        self.currentIndexPath = indexPath.row
        dispatch_async(dispatch_get_main_queue(),{
            self.reloadNavBarItems(articleObject)
        })
        
        if(articleObject.fieldsName!.characters.count == 0) {
            cell.fieldsNameHeightConstraint.constant = 0;
        } else {
            cell.fieldsNameHeightConstraint.constant = 21;
            cell.articleFieldNamelabel.text = articleObject.fieldsName
        }
        cell.webviewHeightConstraint.constant = 20
        cell.articleTitleLabel.text = articleObject.articleTitle!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        self.outletWithContactString = articleObject.outletName!+" | "+articleObject.contactName!
        
        cell.articleContactLabel.text = outletWithContactString
        let dateString:String = Utils.convertTimeStampToDate(articleObject.articlepublishedDate)
        cell.articlePublishedDateLabel.text = "Published: "+dateString
//                print("before removing",articleObject.articleDetailedDescription)
                let removedStyleTagString = articleObject.articleDetailedDescription!.stringByReplacingOccurrencesOfString("style", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//                print("after removing",removedStyleTagString)
                let removeClickText = removedStyleTagString.stringByReplacingOccurrencesOfString("Click here to read full article", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let aStr = String(format: "<body style='color:#777777;font-family:Open Sans;line-height: auto;font-size: 14px;padding:0px;margin:0;'>%@", removeClickText)
        
        //        htmlString = [NSString stringWithFormat:@"<body style='color:#000000;font-family:Open Sans;line-height: 1.7;font-size: 16px;font-weight: 310;'>%@",[curatedNewsDetail valueForKey:@"article"]];
        
        cell.articleDetailWebView.loadHTMLString(aStr, baseURL: nil)

    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        print("flow layout delegate",self.view.frame.size.width,self.view.frame.size.height)
        
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
                    if(isFromDailyDigest) {
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
//        let cell:DetailViewCell = self.collectionView.cellForItemAtIndexPath(self.selectedIndexPath!) as! DetailViewCell
//        cell.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
//        DetailViewCell *cell = (CorporateDetailCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
//        // [cell resetCellWebviewHeight];
//        [cell.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
    
    
    
    func dailyDigestAPICall(pageNo:Int) {
        var nextSetOfArticles = [Article]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callDailyDigestArticleListWebService(0, securityToken: securityToken!, page: pageNo, size: 10){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        
//                        self.articles = CoreDataController().getArticleListForContentTypeId(20, pageNo: 0, entityName: "Article")
//                        self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: CoreDataController().getArticleListForContentTypeId(20, pageNo: pageNo, entityName: "Article"))
                        
                        let nextSetArticles:[Article] = CoreDataController().getArticleListForContentTypeId(20, pageNo: pageNo, entityName: "Article") as [Article]
                        print("next set of articles",nextSetArticles.count)
                        
                        for article in nextSetArticles {
                            self.articleArray.append(article)
                            nextSetOfArticles.append(article)
                        }
                        dispatch_async(dispatch_get_main_queue(),{
                            self.collectionView.reloadData()
                            if let delegate = self.delegate {
                                delegate.controller(self,contentType:20,articleArray: nextSetOfArticles)
                            }
//                            NSNotificationCenter.defaultCenter().postNotificationName("SavedForLaterButtonClick", object:self, userInfo:nextSetOfArticles as ArticleObject)
                        })
                        
                    } else {
                        //handle empty article list
//                        dispatch_async(dispatch_get_main_queue(),{
//                            self.view.makeToast(message: "No more articles to display")
//                        })
                    }
                    
                } else {
                    
                }
            }
        }
        
    }
    
    
    func articleAPICall(activityTypeId:Int,contentTypeId:Int,pagenNo:Int,searchString:String) {
        var nextSetOfArticles = [Article]()
        var nextSetArticles = [Article]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callArticleListWebService(activityTypeId, securityToken: securityToken!, contentTypeId: contentTypeId, page: pagenNo, size: 10,searchString: searchString){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        if(searchString.characters.count != 0) {
                            nextSetArticles = CoreDataController().getSearchArticleList(pagenNo, entityName: "Article")
                        } else {
                            nextSetArticles = CoreDataController().getArticleListForContentTypeId(contentTypeId, pageNo: pagenNo, entityName: "Article") as [Article]
                        }
                        
                        for article in nextSetArticles {
                            self.articleArray.append(article)
                            nextSetOfArticles.append(article)
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            self.collectionView.reloadData()
                            if let delegate = self.delegate {
                                delegate.controller(self,contentType: contentTypeId,articleArray: nextSetOfArticles)
                            }
                        })
                    } else {
                        //handle empty article list
//                        dispatch_async(dispatch_get_main_queue(),{
//                            self.view.makeToast(message: "No more articles to display")
//                        })
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
