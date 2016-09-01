//
//  NewsLetterViewController.swift
//  RANE_App
//
//  Created by cape start on 26/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsLetterViewController: UIViewController {
    @IBOutlet var newsletterListView: UITableView!
    var newsletterArray = [NewsLetterObject]()
    var titleString:String = ""
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    let netWorkView = UIView()
    var retryButtonClickCount:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.title = titleString
        
        self.getNewsLetterList()
        
        //handle retry button click
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(retryButtonClick),
            name: "RetryButtonClick",
            object: nil)
        
        if(!Reachability.isConnectedToNetwork()) {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            let noNetworkView = NoNetworkView.instanceFromNib()
            netWorkView.frame = CGRectMake((self.view.frame.size.width-noNetworkView.frame.size.width)/2, (self.view.frame.size.height-noNetworkView.frame.size.height)/2, noNetworkView.frame.size.width, noNetworkView.frame.size.height)
            netWorkView.addSubview(noNetworkView)
            self.view.addSubview(netWorkView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getNewsLetterList() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            
            WebServiceManager.sharedInstance.callDailyDigestListWebService(securityToken!) { (json:JSON) in
//                print("newsletter response",json)
                if let results = json.array {
                    self.newsletterArray.removeAll()
                    if(results.count != 0) {
                        for entry in results {
                            self.newsletterArray.append(NewsLetterObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
                            self.newsletterListView.reloadData()
                        })
                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.view.makeToast(message: "No more comments to display")
                        })
                    }
                    
                } else {
                    
                }
            }
        }
    }
    
    func retryButtonClick() {
        self.retryButtonClickCount += 1
        if(Reachability.isConnectedToNetwork()) {
            netWorkView.removeFromSuperview()
            self.getNewsLetterList()
        } else {
            if(self.retryButtonClickCount == 5) {
                self.retryButtonClickCount = 0
                dispatch_async(dispatch_get_main_queue(),{
                    self.view.makeToast(message: "Please check your network connection")
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsletterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomNewsLetterCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let newsletterObject = self.newsletterArray[indexPath.row]
        cell.newsletterName.text = Utils.convertTimeStampToDate(newsletterObject.newsletterCreatedDate)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsletterObject = self.newsletterArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
        vc.isFromDailyDigest = true
        vc.contentTypeId = newsletterObject.newsletterId
        vc.dailyDigestId = newsletterObject.newsletterId
        vc.activityTypeId = 0
        vc.titleString = Utils.convertTimeStampToDate(newsletterObject.newsletterCreatedDate)
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
