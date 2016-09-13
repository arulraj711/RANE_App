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
import PKRevealController


class ListViewController: UIViewController,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,DetailViewControllerDelegate {

    @IBOutlet weak var listNavigationBarItem: UINavigationItem!
    @IBOutlet var listTableView: UITableView!
    var articles = [Article]()
    let groupedArticleArrayList: NSMutableArray = NSMutableArray();
    var contentTypeId:Int = 20 //for daily digest
    var activityTypeId:Int = 0
    var searchKeyword:String = ""
    var titleString:String = ""
    var dailyDigestId:Int = 0
    var isFromDailyDigest:Bool = true
    var isFromListPage:Bool = false
    var retryButtonClickCount:Int = 0
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let listActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let netWorkView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.listTableView.rowHeight = UITableViewAutomaticDimension
        self.listTableView.estimatedRowHeight = 220
    
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                               style: UIBarButtonItemStyle.Plain ,
                                               target: self, action: #selector(ListViewController.OnMenuClicked))
            self.navigationItem.leftBarButtonItem = menu_button_
        } else if(UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let menu_button_ = UIBarButtonItem(image: UIImage(named: "navmenu"),
                                               style: UIBarButtonItemStyle.Plain ,
                                               target: self, action: #selector(ListViewController.OnMenuClicked))
            if(!self.isFromListPage) {
                self.navigationItem.leftBarButtonItem = menu_button_
            }
        }
        
        self.setupView()
        
        
        //Mail button click notification observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(mailButtonClickAction),
            name: "MailButtonClick",
            object: nil)
        
        //MarkedImportant button click notification observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(markedImportantButtonClickAction),
            name: "MarkedImportantButtonClick",
            object: nil)
        
        //Saved for later button click notification observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(savedForLaterButtonClickAction),
            name: "SavedForLaterButtonClick",
            object: nil)
        
        //Update marked important status in list view
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(updateMarkedImportantStatusInList),
            name: "updateMarkedImportantStatus",
            object: nil)
        
        //Update saved for later status in list view
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(updateSavedForLaterStatusInList),
            name: "updateSavedForLaterStatus",
            object: nil)
        
        //handle session expired
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(handleSessionExpired),
            name: "SessionExpired",
            object: nil)
        
        
        //handle retry button click
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(retryButtonClick),
            name: "RetryButtonClick",
            object: nil)
        
        
//        UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
//        [spinner startAnimating];
//        spinner.frame = CGRectMake(0, 0, 320, 44);
//        self.tableView.tableFooterView = spinner;
        
        
        
                    //myActivityIndicator.center = view.center
       
        myActivityIndicator.stopAnimating()
        
        
        if(!Reachability.isConnectedToNetwork()) {
            listActivityIndicator.stopAnimating()
            listActivityIndicator.removeFromSuperview()
            let noNetworkView = NoNetworkView.instanceFromNib()
            netWorkView.frame = CGRectMake((self.view.frame.size.width-noNetworkView.frame.size.width)/2, (self.view.frame.size.height-noNetworkView.frame.size.height)/2, noNetworkView.frame.size.width, noNetworkView.frame.size.height)
            netWorkView.addSubview(noNetworkView)
            self.view.addSubview(netWorkView)
        }
    }

    
    func setupView (){
        print("company type id--->",self.contentTypeId)
        if(self.searchKeyword.characters.count == 0) {
            self.articles = CoreDataController().getArticleListForContentTypeId(contentTypeId, pageNo: 0, entityName: "Article")
            if(isFromDailyDigest) {
                if(self.articles.count != 0) {
                    self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: self.articles)
                }
            } else {
                if(self.articles.count != 0) {
                    self.groupByModifiedDate(self.articles)
                    
                }
                
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.listTableView.reloadData()
            })
            if(isFromDailyDigest) {
                //for daily digest
                if(self.dailyDigestId == 0) {
                    let imageName = "nav_logo"
                    let image = UIImage(named: imageName)
                    let imageView = UIImageView(image: image!)
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit;
                    self.navigationItem.titleView = imageView
                } else {
                    self.title = titleString
                }
                
                if(self.articles.count == 0) {
                    listActivityIndicator.center = self.view.center
                    listActivityIndicator.startAnimating()
                    self.view.addSubview(listActivityIndicator)
                    self.dailyDigestAPICall(0,dailyDigestId: dailyDigestId)
                }
            } else {
                //for normal article list
                
                self.title = titleString
                if(self.articles.count == 0) {
                    listActivityIndicator.center = self.view.center
                    listActivityIndicator.startAnimating()
                    self.view.addSubview(listActivityIndicator)
                    self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:0,searchString: self.searchKeyword)
                }
                
            }
        } else {
            self.articles = CoreDataController().getSearchArticleList(0, entityName: "Article")
            self.groupByModifiedDate(self.articles)
            dispatch_async(dispatch_get_main_queue(),{
                self.listTableView.reloadData()
            })
            self.title = titleString
            if(self.articles.count == 0) {
                listActivityIndicator.center = self.view.center
                listActivityIndicator.startAnimating()
                self.view.addSubview(listActivityIndicator)
                self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:0,searchString: self.searchKeyword)
            }
            
        }
    }
    
    
    
    func controller(controller: DetailViewController,contentType:Int ,articleArray:[Article]) {
        print("delegate called",articleArray.count)
        
//        for article in articleArray {
//            self.articles.append(article)
//        }
        
        
        if(isFromDailyDigest) {
            self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: articleArray)
        } else {
            self.groupByModifiedDate(articleArray)
        }
        
        if(self.searchKeyword.characters.count == 0) {
            self.articles = CoreDataController().getArticleListForContentTypeId(contentTypeId, pageNo: 0, entityName: "Article")
        } else {
            self.articles = CoreDataController().getSearchArticleList(0, entityName: "Article")
        }
        
        dispatch_async(dispatch_get_main_queue(),{
            //self.tableView.reloadData()
            self.listTableView.reloadData()
//            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//            //myActivityIndicator.center = view.center
//            myActivityIndicator.startAnimating()
//            self.listTableView.tableFooterView = myActivityIndicator;
        })

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
    
    func getExistingGroupNamesList() -> NSMutableArray {
        let existingGroupNameArray:NSMutableArray = NSMutableArray()
        for dic in self.groupedArticleArrayList {
            existingGroupNameArray.addObject(dic.objectForKey("sectionName")!)
        }
        return existingGroupNameArray
    }
    
    
    func getExistingGroupedArticle(sectionName:String) -> [Article]{
        var existingGroupedArticle = [Article]()
        for dic in self.groupedArticleArrayList {
            if(String(dic.objectForKey("sectionName")!) == sectionName) {
                existingGroupedArticle = dic.objectForKey("articleList") as! [Article]
            } else {
                continue
            }
        }
        return existingGroupedArticle
    }
    
    func getGroupedArticleIndex(sectionName:String) -> Int {
        var index:Int = 0
        for dic in self.groupedArticleArrayList {
            if(String(dic.objectForKey("sectionName")!) == sectionName) {
                index = self.groupedArticleArrayList.indexOfObject(dic)
            } else {
                continue
            }
        }
        return index
    }
    
    func groupByModifiedDate(articleArray:[Article]) {
        let articleModifiedDateList = self.getArticlePubslishedDateList(articleArray)
        for articleModifiedDate in articleModifiedDateList {
            let existingGroupNameList:NSMutableArray = self.getExistingGroupNamesList()
            let existingGroupArticles:[Article] = self.getExistingGroupedArticle(String(articleModifiedDate))
            let groupedArticleArray = self.groupArticlesBasedOnModofiedDate(articleModifiedDate as! String, articleArray: articleArray,existingGroupedArticle: existingGroupArticles)

            if(existingGroupNameList.containsObject(articleModifiedDate as! String)) {
                let index:Int = self.getGroupedArticleIndex(String(articleModifiedDate))
                    self.groupedArticleArrayList.removeObjectAtIndex(index)
                    let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                    articleGroupDictionary.setValue(String(articleModifiedDate), forKey: "sectionName")
                    articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                    self.groupedArticleArrayList.insertObject(articleGroupDictionary, atIndex: index)
              //  }
            } else {
                if(groupedArticleArray.count != 0) {
                    let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                    articleGroupDictionary.setValue(String(articleModifiedDate), forKey: "sectionName")
                    articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                    self.groupedArticleArrayList.addObject(articleGroupDictionary)
//                    self.groupedArticleArrayList.insertObject(articleGroupDictionary, atIndex: self.groupedArticleArrayList.count)
                }
            }
            
        }
    }
    
    func groupArticlesBasedOnModofiedDate(modifiedDate:String,articleArray:[Article],existingGroupedArticle:[Article]) -> [Article] {
        var tempArray = [Article]()
        tempArray = existingGroupedArticle
        for article in articleArray {
            if(Utils.convertTimeStampToDate(article.articleModifiedDate) == modifiedDate) {
                tempArray.append(article)
            } else {
                continue
            }
        }
        return tempArray
    }
    
    func getArticlePubslishedDateList(articleArray:[Article]) -> NSMutableArray {
        let articlePublishedDateArray: NSMutableArray = NSMutableArray()
//        articlePublishedDateArray = self.getExistingGroupNamesList()
        for article in articleArray {
           
            
            if(articlePublishedDateArray.containsObject(Utils.convertTimeStampToDate(article.articleModifiedDate))) {
               continue
            } else {
                articlePublishedDateArray.addObject(Utils.convertTimeStampToDate(article.articleModifiedDate))
            }
        }
        return articlePublishedDateArray
    }
    
    func groupByContentType(menuArray:[Menu],articleArray:[Article]) {
        //self.groupedArticleArrayList.removeAllObjects()
        print("incoming article array count",articleArray.count)
        for menu in menuArray {
            let existingGroupNameList:NSMutableArray = self.getExistingGroupNamesList()
            let existingGroupArticles:[Article] = self.getExistingGroupedArticle(menu.menuName)
            let groupedArticleArray = self.groupArticlesBasedOnContentType(menu.companyId.integerValue, articletypeId: menu.menuId.integerValue, articleArray: articleArray,existingGroupedAricles: existingGroupArticles)
            if(existingGroupNameList.containsObject(menu.menuName)) {
                let index:Int = self.getGroupedArticleIndex(String(menu.menuName))
                self.groupedArticleArrayList.removeObjectAtIndex(index)
                let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                articleGroupDictionary.setValue(menu.menuName, forKey: "sectionName")
                articleGroupDictionary.setValue(menu.menuId, forKey: "sectionId")
                articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                self.groupedArticleArrayList.insertObject(articleGroupDictionary, atIndex: index)
            } else {
                if(groupedArticleArray.count != 0) {
                    let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                    articleGroupDictionary.setValue(menu.menuName, forKey: "sectionName")
                    articleGroupDictionary.setValue(menu.menuId, forKey: "sectionId")
                    articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                    self.groupedArticleArrayList.addObject(articleGroupDictionary)
                }

            }
        }
    }
    
    func groupArticlesBasedOnContentType(companyId:Int,articletypeId:Int,articleArray:[Article],existingGroupedAricles:[Article])-> [Article]{
        var tempArray = [Article]()
        tempArray = existingGroupedAricles
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
        let expandButton = UIButton()
        let fullExpandButton = UIButton()
        let dividerView = UIView()
        
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(section) as! NSDictionary
        if(section == 0) {
            if(self.isFromDailyDigest) {
                headerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 77)
                dividerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 5)
                label.frame = CGRectMake(20, 26, tableView.bounds.size.width-60, 47)
                expandButton.frame = CGRectMake(tableView.bounds.size.width-27, 41, 20, 20)
            } else {
                headerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 72)
                dividerView.frame = CGRectMake(0, 21, tableView.bounds.size.width, 5)
                label.frame = CGRectMake(20, 21, tableView.bounds.size.width-60, 52)
                expandButton.frame = CGRectMake(tableView.bounds.size.width-27, 36, 20, 20)
            }
            
            dividerView.backgroundColor = UIColor.init(red: 31/255, green: 55/255, blue: 118/255, alpha: 1)
            headerColorView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 20)
            headerColorView.backgroundColor = UIColor.init(colorLiteralRed: 241/255, green: 241/255, blue: 245/255, alpha: 1)
            headerView.addSubview(headerColorView)
            if ((singleDic.objectForKey("sectionId") as? Int) != nil) {
                expandButton.setImage(UIImage(named: "expandbutton"), forState: .Normal)
                fullExpandButton.frame = CGRectMake(0, 21, tableView.bounds.size.width, 72)
                fullExpandButton.tag = section
                fullExpandButton.addTarget(self, action: #selector(ListViewController.expandButtonClick(_:)), forControlEvents: .TouchUpInside)
                headerView.addSubview(fullExpandButton)
                headerView.addSubview(expandButton)
            }
            
        } else {
            if(self.isFromDailyDigest) {
                headerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 57)
                dividerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 5)
                label.frame = CGRectMake(20, 5, tableView.bounds.size.width-60, 47)
                expandButton.frame = CGRectMake(tableView.bounds.size.width-27, 21, 20, 20)
            } else {
                headerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 52)
                dividerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 5)
                label.frame = CGRectMake(20, 0, tableView.bounds.size.width-60, 52)
                expandButton.frame = CGRectMake(tableView.bounds.size.width-27, 16, 20, 20)
            }
            
            dividerView.backgroundColor = UIColor.init(red: 31/255, green: 55/255, blue: 118/255, alpha: 1)
            
            
            if ((singleDic.objectForKey("sectionId") as? Int) != nil) {
                expandButton.setImage(UIImage(named: "expandbutton"), forState: .Normal)
                fullExpandButton.frame = CGRectMake(0, 0, tableView.bounds.size.width, 52)
                fullExpandButton.tag = section
                fullExpandButton.addTarget(self, action: #selector(ListViewController.expandButtonClick(_:)), forControlEvents: .TouchUpInside)
                headerView.addSubview(fullExpandButton)
                headerView.addSubview(expandButton)
            }
        }
        print("section name",singleDic.objectForKey("sectionName"))
        print("after section name",singleDic.objectForKey("sectionName") as? String)
        label.text = singleDic.objectForKey("sectionName") as? String
        headerView.backgroundColor = UIColor.whiteColor()
        label.font = UIFont(name:"OpenSans-Semibold", size: 14)
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        /* code for top shadow
        headerView.layer.shadowColor = UIColor.blackColor().CGColor
        headerView.layer.shadowOffset = CGSizeMake(0.0, -5.0)
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowRadius = 8
        */
        headerView.addSubview(dividerView)
        return headerView
    }
    
    func expandButtonClick(sender:UIButton){
        print("exapnd button tag",sender.tag)
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(sender.tag) as! NSDictionary
//        print("singel dic",singleDic)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
        vc.activityTypeId = 0
        vc.contentTypeId = (singleDic.objectForKey("sectionId") as? Int)!
        vc.titleString = (singleDic.objectForKey("sectionName") as? String)!
        vc.isFromDailyDigest = false
        vc.isFromListPage = true
        self.navigationController?.pushViewController(vc, animated: true)
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
        let articleObject:Article = articleArray![indexPath.row] as! Article
        cell.cellArticleObject = articleObject
        if(articleObject.fieldsName!.characters.count == 0) {
            cell.fieldNameLabelHeightConstraint.constant=0
        } else {
            cell.fieldNameLabelHeightConstraint.constant=20
            cell.fieldName.text = articleObject.fieldsName
        }
       // print("one")
        cell.articleTitle.text = articleObject.articleTitle!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        //print("two")
        cell.articleDescription.text = articleObject.articleDescription!
        cell.outletName.text = articleObject.outletName!
        
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
        
        var articleGroupArray = [Article]()
        for dic in self.groupedArticleArrayList {
            for articleObject in (dic.objectForKey("articleList") as? NSArray)! {
                articleGroupArray.append(articleObject as! Article)
            }
        }
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(indexPath.section) as! NSDictionary
        let articleArray: NSArray?   = singleDic.objectForKey("articleList") as? NSArray;
        let articleObject:Article = articleArray![indexPath.row] as! Article
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "fromListPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:DetailViewController = storyboard.instantiateViewControllerWithIdentifier("detailView") as! DetailViewController
        vc.articleArray = articleGroupArray
        vc.delegate = self
        print("selected index",self.getSelectedArticlePostion(articleObject, articleArray: articleGroupArray))
        vc.currentindex = self.getSelectedArticlePostion(articleObject, articleArray: articleGroupArray)
        vc.contentTypeId = self.contentTypeId
        vc.activityTypeId = self.activityTypeId
        vc.dailyDigestId = self.dailyDigestId
        vc.searchKeyword = self.searchKeyword
        vc.isFromDailyDigest = self.isFromDailyDigest
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func retryButtonClick() {
        self.retryButtonClickCount += 1
        if(Reachability.isConnectedToNetwork()) {
            netWorkView.removeFromSuperview()
            self.setupView()
        } else {
            if(self.retryButtonClickCount == 5) {
                self.retryButtonClickCount = 0
                dispatch_async(dispatch_get_main_queue(),{
                    self.view.makeToast(message: "Please check your network connection")
                })
            }
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
    
    
    
    func savedForLaterButtonClickAction(notification: NSNotification) {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            if let info = notification.userInfo as? Dictionary<String,String> {
                let userActivitiesInputDictionary: NSMutableDictionary = NSMutableDictionary()
                userActivitiesInputDictionary.setValue("3", forKey: "status")
                userActivitiesInputDictionary.setValue(info["articleId"], forKey: "selectedArticleId")
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
                    
                }
            }
        }
    }
    
    func updateSavedForLaterStatusInList(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,String> {
            for article in self.articles {
                if(article.articleId == info["articleId"]) {
                    if(info["isSaved"] == "1") {
//                        article.isSavedForLater = 0
                        if(self.isFromDailyDigest) {
                            CoreDataController().updateSavedForLaterStatusInArticle(info["articleId"]!,contentTypeId: self.dailyDigestId ,isSaved: 0,isSavedSync: Reachability.isConnectedToNetwork())
                        } else {
                            CoreDataController().updateSavedForLaterStatusInArticle(info["articleId"]!,contentTypeId: self.contentTypeId ,isSaved: 0,isSavedSync: Reachability.isConnectedToNetwork())
                        }
                        
                    } else if(info["isSaved"] == "0"){
//                        article.isSavedForLater = 1
                        if(self.isFromDailyDigest) {
                            CoreDataController().updateSavedForLaterStatusInArticle(info["articleId"]!, contentTypeId: self.dailyDigestId,isSaved: 1,isSavedSync: Reachability.isConnectedToNetwork())
                        } else {
                            CoreDataController().updateSavedForLaterStatusInArticle(info["articleId"]!, contentTypeId: self.contentTypeId,isSaved: 1,isSavedSync: Reachability.isConnectedToNetwork())
                        }
                        
                    }
                    
                }
            }
            //self.groupedArticleArrayList.removeAllObjects()
            //self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: self.articles)
            self.listTableView.reloadData()
        }
        
    }
    
    func updateMarkedImportantStatusInList(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,String> {
            for article in self.articles {
                if(article.articleId == info["articleId"]) {
                    print("Reachability",Reachability.isConnectedToNetwork())
                    if(info["isMarked"] == "1") {
//                        article.isMarkedImportant = 0
                        if(self.isFromDailyDigest) {
                            CoreDataController().updateMarkedImportantStatusInArticle(info["articleId"]!,contentTypeId: self.dailyDigestId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                        } else {
                            CoreDataController().updateMarkedImportantStatusInArticle(info["articleId"]!,contentTypeId: self.contentTypeId, isMarked: 0,isMarkedImpSync: Reachability.isConnectedToNetwork())
                        }
                        
                    } else if(info["isMarked"] == "0"){
//                        article.isMarkedImportant = 1
                        if(self.isFromDailyDigest) {
                            CoreDataController().updateMarkedImportantStatusInArticle(info["articleId"]!, contentTypeId: self.dailyDigestId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                        } else {
                            CoreDataController().updateMarkedImportantStatusInArticle(info["articleId"]!, contentTypeId: self.contentTypeId,isMarked: 1,isMarkedImpSync: Reachability.isConnectedToNetwork())
                        }
                        
                    }
                    
                }
            }
           // self.groupedArticleArrayList.removeAllObjects()
           // self.groupByContentType(WebServiceManager.sharedInstance.menuItems, articleArray: self.articles)
            self.listTableView.reloadData()
        }
        
    }
    
    
    func markedImportantButtonClickAction(notification: NSNotification) {
        
        // This method is invoked when the notification is sent
        
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            if let info = notification.userInfo as? Dictionary<String,String> {
                let userActivitiesInputDictionary: NSMutableDictionary = NSMutableDictionary()
                userActivitiesInputDictionary.setValue("2", forKey: "status")
                userActivitiesInputDictionary.setValue(info["articleId"], forKey: "selectedArticleId")
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
                        userActivitiesInputDictionary.setValue(false, forKey: "isSelected")
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            var dataDict = Dictionary<String, String>()
                            dataDict["articleId"] = info["articleId"]
                            dataDict["isMarked"] = info["isMarked"]
                            NSNotificationCenter.defaultCenter().postNotificationName("updateMarkedImportantStatus", object:self, userInfo:dataDict)
                            
                        })
                        
                        print("marked important userdic",userActivitiesInputDictionary)
                        WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                            
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
                    
                    print("marked important userdic",userActivitiesInputDictionary)
                    WebServiceManager.sharedInstance.callUserActivitiesOnArticlesWebService(userActivitiesInputDictionary) { (json:JSON) in
                        
                    }
                }
                
            }
        }
    }
    
    func mailButtonClickAction(notification: NSNotification) {
        
        // This method is invoked when the notification is sent
        if let info = notification.userInfo as? Dictionary<String,String> {
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
    
    func getSelectedArticlePostion(article:Article,articleArray:[Article]) -> Int {
        for (index,articleObj) in articleArray.enumerate() {
            if(articleObj.articleId == article.articleId) {
                return index
            }
        }
        return 0
    }
    
    
    func OnMenuClicked() {
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            self.navigationController?.popViewControllerAnimated(true)
        } else if(UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
           print("reveal controller state",self.revealController.state)
            if(self.revealController.state == PKRevealControllerShowsFrontViewController) {
                self.revealController.showViewController(self.revealController.leftViewController)
            } else {
                self.revealController.showViewController(self.revealController.frontViewController)
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       // print("current indexpath",indexPath.section,indexPath.row)
//        print("total items",self.articles.count)
        let singleDic:NSDictionary = self.groupedArticleArrayList.objectAtIndex(indexPath.section) as! NSDictionary
        let articleArray: NSArray?   = singleDic.objectForKey("articleList") as? NSArray;
        let articleObject:Article = articleArray![indexPath.row] as! Article
        let lastArticle:Article = self.articles.last!
        //print("before will")
        if(articleObject.articleId == lastArticle.articleId) {
           // print("reached end")
            var pageNo:Int?
            let mod:Int = self.articles.count%10
            if (mod == 0) {
                pageNo  = self.articles.count/10;
                
            } else {
                let defaultValue:Int = 10-mod;
                pageNo  = (self.articles.count+defaultValue)/10;
                
            }
            
            
            if(self.searchKeyword.characters.count == 0) {
                if(isFromDailyDigest) {
                    //for daily digest
                    self.dailyDigestAPICall(pageNo!,dailyDigestId: dailyDigestId)
                } else {
                    //for normal article list
                    self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
                }
            } else {
                self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
            }

        }
        
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
        
//        print("y value",y)
//        print("h value",h!)
//        print("reload distance",reload_distance!)
        
        if(y > h! + reload_distance!) {
            //reached end of scroll
            if (mod == 0) {
                pageNo  = self.articles.count/10;
                
            } else {
                let defaultValue:Int = 10-mod;
                pageNo  = (self.articles.count+defaultValue)/10;
                
            }
            
            
//            if(self.searchKeyword.characters.count == 0) {
//                if(self.contentTypeId == 20) {
//                    //for daily digest
//                    self.dailyDigestAPICall(pageNo!)
//                } else {
//                    //for normal article list
//                    self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
//                }
//            } else {
//                self.articleAPICall(self.activityTypeId, contentTypeId: self.contentTypeId, pagenNo:pageNo!,searchString: self.searchKeyword)
//            }
        } else {
            //top scrolling
        }
    }

   
    
    func dailyDigestAPICall(pageNo:Int,dailyDigestId:Int) {
//        var nextSetOfArticles = [ArticleObject]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callDailyDigestArticleListWebService(dailyDigestId, securityToken: securityToken!, page: pageNo, size: 10){ (json:JSON) in
                
                if let results = json.array {
                    if(results.count != 0) {
                        self.articles = CoreDataController().getArticleListForContentTypeId(dailyDigestId, pageNo: 0, entityName: "Article")
                        print("newsletter article count",self.articles.count)
                        self.groupByContentType(CoreDataController().getEntityInfoFromCoreData("Menu"), articleArray: CoreDataController().getArticleListForContentTypeId(dailyDigestId, pageNo: pageNo, entityName: "Article"))
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.listTableView.reloadData()
                            self.myActivityIndicator.startAnimating()
                            self.listTableView.tableFooterView = self.myActivityIndicator;
                            self.listActivityIndicator.stopAnimating()
                            self.listActivityIndicator.removeFromSuperview()

                        })

                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            if(pageNo == 0) {
                                self.view.makeToast(message: "No articles to display")
                            }
                             self.myActivityIndicator.stopAnimating()
                            self.listActivityIndicator.stopAnimating()
                            self.listActivityIndicator.removeFromSuperview()
                        })
                    }
                    
                } else {
    
                }
            }
        }

    }
    
    
    func articleAPICall(activityTypeId:Int,contentTypeId:Int,pagenNo:Int,searchString:String) {
//        var nextSetOfArticles = [ArticleObject]()
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callArticleListWebService(activityTypeId, securityToken: securityToken!, contentTypeId: contentTypeId, page: pagenNo, size: 10,searchString: searchString){ (json:JSON) in
                
                if let results = json.array {
                    if(results.count != 0) {
                        if(searchString.characters.count != 0) {
                            self.articles = CoreDataController().getSearchArticleList(0, entityName: "Article")
                            print("db article",self.articles.count)
                            self.groupByModifiedDate(CoreDataController().getSearchArticleList(pagenNo, entityName: "Article"))
                        } else {
                            self.articles = CoreDataController().getArticleListForContentTypeId(contentTypeId, pageNo: 0, entityName: "Article")
                            self.groupByModifiedDate(CoreDataController().getArticleListForContentTypeId(contentTypeId, pageNo: pagenNo, entityName: "Article"))
                        }
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.listTableView.reloadData()
                            self.myActivityIndicator.startAnimating()
                            self.listTableView.tableFooterView = self.myActivityIndicator;
                            self.listActivityIndicator.stopAnimating()
                            self.listActivityIndicator.removeFromSuperview()
                        })
                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            if(pagenNo == 0) {
                                self.view.makeToast(message: "No articles to display")
                            }
                            self.myActivityIndicator.stopAnimating()
                            self.listActivityIndicator.stopAnimating()
                            self.listActivityIndicator.removeFromSuperview()
                        })
                    }
                    
                } else {
                    if(searchString.characters.count == 0) {
                        self.articles.removeAll()
                        self.groupByModifiedDate(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            self.listTableView.reloadData()
                        })
                    }
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
