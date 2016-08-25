//
//  ListViewController.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI


class ListViewController: UIViewController,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var listNavigationBarItem: UINavigationItem!
    @IBOutlet var listTableView: UITableView!
    var articles = [ArticleObject]()
    let groupedArticleArrayList: NSMutableArray = NSMutableArray();
    var contentTypeId:Int = 20 //for daily digest
    var activityTypeId:Int = 0
    var searchKeyword:String = ""
    var titleString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.listTableView.rowHeight = UITableViewAutomaticDimension
        self.listTableView.estimatedRowHeight = 220
        
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                           style: UIBarButtonItemStyle.Plain ,
                                           target: self, action: #selector(ListViewController.OnMenuClicked))
        self.navigationItem.leftBarButtonItem = menu_button_

        
        print("company type id--->",self.contentTypeId)
        if(self.searchKeyword.characters.count == 0) {
            if(self.contentTypeId == 20) {
                //for daily digest
                
                let imageName = "nav_logo"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit;
                self.navigationItem.titleView = imageView
                
                self.dailyDigestAPICall(0)
            } else {
                //for normal article list
                
                self.title = titleString
                
                self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:0,searchString: self.searchKeyword)
            }
        } else {
            self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:0,searchString: self.searchKeyword)
        }
        
        //Mail button click notification observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(mailButtonClickAction),
            name: "MailButtonClick",
            object: nil)
    }

    override func viewDidAppear(animated: Bool) {

    }
    
    
    
//    func testGroup(articleArray:[ArticleObject]) {
//        let testArray:NSMutableArray = NSMutableArray()
//        let dic:NSMutableDictionary = NSMutableDictionary()
//        for article in self.articles {
//            var testArticles = [ArticleObject]()
//            let articleModifiedDate = Utils.convertTimeStampToDate(article.articleModifiedDate)
//            if((dic.objectForKey(articleModifiedDate)) != nil) {
//                testArticles = dic.objectForKey(articleModifiedDate) as! [ArticleObject]
//                testArticles.append(article)
//                dic.setObject(testArticles, forKey: articleModifiedDate)
////                orderedDic.insertElementWithKey(articlePublishedDate, value: testArticles, atIndex: index)
//                
//            } else {
//                testArticles.append(article)
//                dic.setObject(testArticles, forKey: articleModifiedDate)
////                orderedDic.insertElementWithKey(articlePublishedDate, value: testArticles, atIndex: index)
//            }
//        }
//        print("final dic",dic)
//        print("array format",testArray)
//        print("final keys",dic.allKeys)
//        print("final values",dic.allValues)
//    }
//    
//    
//    func testModuleGroup(articleArray:[ArticleObject]) {
//        let testArray:NSMutableArray = NSMutableArray()
//        let dic:NSMutableDictionary = NSMutableDictionary()
//        for article in self.articles {
//            var testArticles = [ArticleObject]()
//            let articleModifiedDate = Utils.convertTimeStampToDate(article.articleModifiedDate)
//            if((dic.objectForKey(articleModifiedDate)) != nil) {
//                testArticles = dic.objectForKey(articleModifiedDate) as! [ArticleObject]
//                testArticles.append(article)
//                dic.setObject(testArticles, forKey: articleModifiedDate)
//                //                orderedDic.insertElementWithKey(articlePublishedDate, value: testArticles, atIndex: index)
//                
//            } else {
//                testArticles.append(article)
//                dic.setObject(testArticles, forKey: articleModifiedDate)
//                //                orderedDic.insertElementWithKey(articlePublishedDate, value: testArticles, atIndex: index)
//            }
//        }
//        print("final dic",dic)
//        print("array format",testArray)
//        print("final keys",dic.allKeys)
//        print("final values",dic.allValues)
//    }
    
    
    func groupByModifiedDate(articleArray:[ArticleObject]) {
        self.groupedArticleArrayList.removeAllObjects()
        let articleModifiedDateList = self.getArticlePubslishedDateList(articleArray)
        print("published date array",articleModifiedDateList)
        for articleModifiedDate in articleModifiedDateList {
            print("inside for loop",articleModifiedDate)
            let groupedArticleArray = self.groupArticlesBasedOnModofiedDate(articleModifiedDate as! String, articleArray: articleArray)
            if(groupedArticleArray.count != 0) {
                let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                
                articleGroupDictionary.setValue(articleModifiedDate, forKey: "sectionName")
                articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                self.groupedArticleArrayList.addObject(articleGroupDictionary)
            }
        }
    }
    
    func groupArticlesBasedOnModofiedDate(modifiedDate:String,articleArray:[ArticleObject]) -> [ArticleObject] {
        var tempArray = [ArticleObject]()
        for article in articleArray {
            print("olddd")
            print("old",Utils.convertTimeStampToDate(article.articleModifiedDate))
            print("new",modifiedDate)
            if(Utils.convertTimeStampToDate(article.articleModifiedDate) == modifiedDate) {
                tempArray.append(article)
            } else {
                continue
            }
        }
        return tempArray
    }
    
    func getArticlePubslishedDateList(articleArray:[ArticleObject]) -> NSMutableArray {
        let articlePublishedDateArray: NSMutableArray = NSMutableArray()
        for article in articleArray {
           
            
            if(articlePublishedDateArray.containsObject(Utils.convertTimeStampToDate(article.articleModifiedDate))) {
               continue
            } else {
                articlePublishedDateArray.addObject(Utils.convertTimeStampToDate(article.articleModifiedDate))
            }
        }
        return articlePublishedDateArray
    }
    
    func groupByContentType(menuArray:[MenuObject],articleArray:[ArticleObject]) {
        self.groupedArticleArrayList.removeAllObjects()
        for menu in menuArray {
            let groupedArticleArray = self.groupArticlesBasedOnContentType(menu.companyId, articletypeId: menu.menuId, articleArray: articleArray)
                if(groupedArticleArray.count != 0) {
                    let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                    articleGroupDictionary.setValue(menu.menuName, forKey: "sectionName")
                    articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                    self.groupedArticleArrayList.addObject(articleGroupDictionary)
                }
        }
    }
    
    func groupArticlesBasedOnContentType(companyId:Int,articletypeId:Int,articleArray:[ArticleObject])-> [ArticleObject]{
        var tempArray = [ArticleObject]()
        for article in articleArray {
            if(article.articleTypeId == articletypeId && article.companyId == companyId) {
                tempArray.append(article)
            } else {
                continue
            }
        }
        return tempArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.groupedArticleArrayList.count
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView!
    {
        let headerView:UIView = UIView()
        let label:UILabel = UILabel()
        let headerColorView:UIView = UIView()
        var imageViewObject :UIImageView
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(section) as! NSDictionary
        if(section == 0) {
            headerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 72)
            label.frame = CGRectMake(20, 21, tableView.bounds.size.width-60, 52)
            headerColorView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 20)
            imageViewObject = UIImageView(frame:CGRectMake(tableView.bounds.size.width-27, 36, 8, 20));
            headerColorView.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 241/255, blue: 245/255, alpha: 1)
            headerView.addSubview(headerColorView)
            imageViewObject.image = UIImage(named:"expandbutton")
            headerView.addSubview(imageViewObject)
        } else {
            headerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 52)
            label.frame = CGRectMake(20, 0, tableView.bounds.size.width-60, 52)
            imageViewObject = UIImageView(frame:CGRectMake(tableView.bounds.size.width-27, 16, 8, 20));
            imageViewObject.image = UIImage(named:"expandbutton")
            headerView.addSubview(imageViewObject)
        }
        print("section name",singleDic.objectForKey("sectionName"))
        print("after section name",singleDic.objectForKey("sectionName") as? String)
        label.text = singleDic.objectForKey("sectionName") as? String
        headerView.backgroundColor = UIColor.whiteColor()
        label.font = UIFont(name:"OpenSans-Semibold", size: 14)
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 72.0
        } else {
            return 52.0
        }
        
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(section) as! NSDictionary
        let itemsArray: NSArray?   = singleDic.objectForKey("articleList") as? NSArray;
        return (itemsArray?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(indexPath.section) as! NSDictionary
    
        let articleArray: NSArray?   = singleDic.objectForKey("articleList") as? NSArray;
        let articleObject:ArticleObject = articleArray![indexPath.row] as! ArticleObject
        cell.cellArticleObject = articleObject
        if(articleObject.fieldsName.characters.count == 0) {
            cell.fieldNameLabelHeightConstraint.constant=0
        } else {
            cell.fieldNameLabelHeightConstraint.constant=20
            cell.fieldName.text = articleObject.fieldsName
        }
        
        cell.articleTitle.text = articleObject.articleTitle.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        cell.articleDescription.text = articleObject.articleDescription
        cell.outletName.text = articleObject.outletName.uppercaseString
        
        //highlight marked important articles
        if (articleObject.isMarkedImportant == 1) {
            cell.markedImportantButton.selected = true
        } else {
            cell.markedImportantButton.selected = false
        }
        
        //highlight saved for later articles
        if (articleObject.isSavedForLater == 1) {
            cell.savedForLaterButton.selected = true
        } else {
            cell.savedForLaterButton.selected = false
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var articleGroupArray = [ArticleObject]()
        for dic in self.groupedArticleArrayList {
            print("dic",dic)
            for articleObject in (dic.objectForKey("articleList") as? NSArray)! {
                articleGroupArray.append(articleObject as! ArticleObject)
            }
            print("article array",articleGroupArray)
        }
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(indexPath.section) as! NSDictionary
        let articleArray: NSArray?   = singleDic.objectForKey("articleList") as? NSArray;
        let articleObject:ArticleObject = articleArray![indexPath.row] as! ArticleObject
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:DetailViewController = storyboard.instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        vc.articleArray = articleGroupArray
        print("selected index",self.getSelectedArticlePostion(articleObject, articleArray: articleGroupArray))
        vc.currentindex = self.getSelectedArticlePostion(articleObject, articleArray: articleGroupArray)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func mailButtonClickAction(notification: NSNotification) {
        
        // This method is invoked when the notification is sent
        if let info = notification.userInfo as? Dictionary<String,String> {
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
    
    func getSelectedArticlePostion(article:ArticleObject,articleArray:[ArticleObject]) -> Int {
        for (index,articleObj) in articleArray.enumerate() {
            if(articleObj.articleId == article.articleId) {
                return index
            }
        }
        return 0
    }
    
    
    func OnMenuClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let offset:CGPoint = self.listTableView.contentOffset;
        let bounds:CGRect = self.listTableView.bounds
        let size:CGSize = self.listTableView.contentSize
        let inset:UIEdgeInsets = self.listTableView.contentInset
        var y,h,reload_distance:CGFloat?
        var pageNo:Int?
        let mod:Int = self.articles.count%10
        
    
        y = offset.y + bounds.size.height - inset.bottom;
        h = size.height;
        reload_distance = 50;
        
        if(y > h! + reload_distance!) {
            //reached end of scroll
            if (mod == 0) {
                pageNo  = self.articles.count/10;
                
            } else {
                let defaultValue:Int = 10-mod;
                pageNo  = (self.articles.count+defaultValue)/10;
                
            }
            
            
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
        } else {
            //top scrolling
        }
    }

   
    
    func dailyDigestAPICall(pageNo:Int) {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callDailyDigestArticleListWebService(0, securityToken: securityToken!, page: pageNo, size: 10){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        for entry in results {
                            self.articles.append(ArticleObject(json: entry))
                        }
                        self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.listTableView.reloadData()
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
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callArticleListWebService(activityTypeId, securityToken: securityToken!, contentTypeId: contentTypeId, page: pagenNo, size: 10,searchString: searchString){ (json:JSON) in
                if let results = json.array {
                    if(results.count != 0) {
                        for entry in results {
                            self.articles.append(ArticleObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        self.groupByModifiedDate(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.listTableView.reloadData()
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
