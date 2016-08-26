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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getNewsLetterList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getNewsLetterList() {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            
            WebServiceManager.sharedInstance.callDailyDigestListWebService(securityToken!) { (json:JSON) in
                print("newsletter response",json)
                if let results = json.array {
                    self.newsletterArray.removeAll()
                    if(results.count != 0) {
                        for entry in results {
                            self.newsletterArray.append(NewsLetterObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsletterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomNewsLetterCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let newsletterObject = self.newsletterArray[indexPath.row]
        cell.newsletterName.text = newsletterObject.newsletterName
        cell.articleCountLabel.text = String(newsletterObject.newsletterarticleCount)
//        cell.username.text = commentObject.username
//        cell.comment.sizeToFit()
//        cell.comment.text = commentObject.comment
//        cell.userImage.layer.masksToBounds = true;
//        cell.userImage.layer.cornerRadius = 24.0;
//        cell.userImage.kf_setImageWithURL(NSURL(string:commentObject.photoUrl)!, placeholderImage: UIImage(named: "person_placeholder"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsletterObject = self.newsletterArray[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
        vc.contentTypeId = 20
        vc.dailyDigestId = newsletterObject.newsletterId
        vc.activityTypeId = 0
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
