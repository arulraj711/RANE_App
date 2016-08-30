//
//  FolderViewController.swift
//  RANE_App
//
//  Created by cape start on 30/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON

class FolderViewController: UIViewController {
    @IBOutlet var folderListView: UITableView!
    var folderArray = [FolderObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFolderList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFolderList() {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            
            WebServiceManager.sharedInstance.callFolderListWebService(securityToken!) { (json:JSON) in
                print("folder response",json)
                if let results = json.array {
                    self.folderArray.removeAll()
                    if(results.count != 0) {
                        for entry in results {
                            self.folderArray.append(FolderObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.folderListView.reloadData()
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
        
        return folderArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomFolderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let folderObject = self.folderArray[indexPath.row]
        cell.folderTitle.text = folderObject.folderName
        
        //        cell.newsletterName.text = newsletterObject.newsletterName
        //        cell.articleCountLabel.text = String(newsletterObject.newsletterarticleCount)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let newsletterObject = self.newsletterArray[indexPath.row]
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc:ListViewController = storyboard.instantiateViewControllerWithIdentifier("listView") as! ListViewController
        //        vc.contentTypeId = 20
        //        vc.dailyDigestId = newsletterObject.newsletterId
        //        vc.activityTypeId = 0
        //        self.navigationController?.pushViewController(vc, animated: true)
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
