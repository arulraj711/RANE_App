//
//  ListViewController.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListViewController: UIViewController {

    @IBOutlet weak var listNavigationBarItem: UINavigationItem!
    @IBOutlet var listTableView: UITableView!
    var items = [ArticleObject]()
    
    let groupedArticleArrayList: NSMutableArray = NSMutableArray();
    override func viewDidLoad() {
        super.viewDidLoad()

//        let myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
//        let getThatValue = myCustomViewController.menuItems
//        print("menu items",getThatValue)
        
        
        // Do any additional setup after loading the view.
        let imageName = "nav_logo"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.navigationItem.titleView = imageView
        let menu_button_ = UIBarButtonItem(image: UIImage(named: "backbutton"),
                                       style: UIBarButtonItemStyle.Plain ,
                                       target: self, action: #selector(ListViewController.OnMenuClicked))
        self.navigationItem.leftBarButtonItem = menu_button_
        
       
        
        self.dailyDigestAPICall(0)
    }

    
    func group(menuArray:[MenuObject],articleArray:[ArticleObject]) {
        print("incoming article count",articleArray.count)
        self.groupedArticleArrayList.removeAllObjects()
        for menu in menuArray {
            let groupedArticleArray = self.groupArticles(menu.companyId, articletypeId: menu.menuId, articleArray: articleArray)
                if(groupedArticleArray.count != 0) {
                    let articleGroupDictionary: NSMutableDictionary = NSMutableDictionary()
                    articleGroupDictionary.setValue(menu.menuName, forKey: "sectionName")
                    articleGroupDictionary.setValue(groupedArticleArray, forKey: "articleList")
                    self.groupedArticleArrayList.addObject(articleGroupDictionary)
                }
        }
//        print("after updating--->",self.groupedArticleArrayList)
    }
    
    func groupArticles(companyId:Int,articletypeId:Int,articleArray:[ArticleObject])-> [ArticleObject]{
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
        cell.articleTitle.text = articleObject.articleTitle
        cell.fieldName.text = articleObject.fieldsName
        cell.articleDescription.text = articleObject.articleDescription
        cell.outletName.text = articleObject.outletName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("menu",WebServiceManager.sharedInstance.menuItems);
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
        let mod:Int = self.items.count%10
        
    
        y = offset.y + bounds.size.height - inset.bottom;
        h = size.height;
        reload_distance = 50;
        
        if(y > h! + reload_distance!) {
            //reached end of scroll
            if (mod == 0) {
                pageNo  = self.items.count/10;
                
            } else {
                let defaultValue:Int = 10-mod;
                pageNo  = (self.items.count+defaultValue)/10;
                
            }
            self.dailyDigestAPICall(pageNo!)
            
        } else {
            //top scrolling
        }
    }

   
    
    func dailyDigestAPICall(pageNo:Int) {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            WebServiceManager.sharedInstance.callDailyDigestArticleListWebService(0, securityToken: securityToken!, page: pageNo, size: 10){ (json:JSON) in
                if let results = json.array {
                    print("results",results.count)
                    if(results.count != 0) {
                        for entry in results {
                            self.items.append(ArticleObject(json: entry))
                        }
                        self.group(WebServiceManager.sharedInstance.menuItems, articleArray: self.items)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.listTableView.reloadData()
                        })

                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                        self.view.makeToast(message: "No more articles to display", duration: 1, position: HRToastPositionCenter, title: "Message")
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
