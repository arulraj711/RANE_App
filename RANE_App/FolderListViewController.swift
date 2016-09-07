//
//  FolderListViewController.swift
//  RANE_App
//
//  Created by cape start on 30/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKRevealController

class FolderListViewController: UIViewController,UIAlertViewDelegate {
    var titleString:String = ""
   let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    @IBOutlet var folderListView: UITableView!
    var folderArray = [FolderObject]()
    var isDeleteFolder:Bool = false
    let netWorkView = UIView()
    var retryButtonClickCount:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        self.title = titleString
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            
        } else if(UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            let menu_button_ = UIBarButtonItem(image: UIImage(named: "navmenu"),
                                               style: UIBarButtonItemStyle.Plain ,
                                               target: self, action: #selector(FolderListViewController.OnMenuClicked))
            self.navigationItem.leftBarButtonItem = menu_button_
        }
        
        self.getFolderList()
        
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
    
    func getFolderList() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            
            WebServiceManager.sharedInstance.callFolderListWebService(securityToken!) { (json:JSON) in
//                print("folder response",json)
                if let results = json.array {
                    self.folderArray.removeAll()
                    if(results.count != 0) {
                        for entry in results {
                            self.folderArray.append(FolderObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
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

    func retryButtonClick() {
        self.retryButtonClickCount += 1
        if(Reachability.isConnectedToNetwork()) {
            netWorkView.removeFromSuperview()
            self.getFolderList()
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
        
        return folderArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomFolderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let folderObject = self.folderArray[indexPath.row]
        cell.folderTitle.text = folderObject.folderName
        if(folderObject.defaultFlag) {
            cell.rssButton.hidden = false
            cell.editButon.hidden = true
            cell.deleteButton.hidden = true
        } else {
            cell.rssButton.hidden = true
            cell.editButon.hidden = false
            cell.deleteButton.hidden = false
        }
        cell.rssButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.editButon.tag = indexPath.row
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
    
    @IBAction func rssButtonClick(sender: UIButton) {
        let folderObject = self.folderArray[sender.tag]
        UIPasteboard.generalPasteboard().string = folderObject.rssFeedURL
        dispatch_async(dispatch_get_main_queue(),{
            self.view.makeToast(message: "RSS url copied successfully")
        })

        
    }
    @IBAction func deleteButtonClick(sender: UIButton) {
        self.isDeleteFolder = true
        let alert = UIAlertView()
        alert.title = "Delete"
        alert.message = "Are you sure you want to delete the folder?"
        alert.addButtonWithTitle("Cancel")
        alert.alertViewStyle = UIAlertViewStyle.Default
        alert.addButtonWithTitle("Ok")
        alert.delegate = self
        alert.tag = sender.tag
        alert.show()
    }
    @IBAction func editButtonClick(sender: UIButton) {
        self.isDeleteFolder = false
        let folderObject = self.folderArray[sender.tag]
        let alert = UIAlertView()
        alert.title = "Rename Folder"
        alert.addButtonWithTitle("Cancel")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.addButtonWithTitle("Save")
        alert.delegate = self
        alert.show()
        
        
        let textField = alert.textFieldAtIndex(0)
        textField?.text = folderObject.folderName
        textField?.tag = sender.tag
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("button index",buttonIndex)
        if(buttonIndex == 1) {
            
            if(self.isDeleteFolder) {
                //code for delete folder
                let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
                if(securityToken?.characters.count != 0)  {
                    let folderObject = self.folderArray[alertView.tag]
                    let folderRenameDictionary: NSMutableDictionary = NSMutableDictionary()
                    folderRenameDictionary.setValue(true, forKey: "deleted")
                    WebServiceManager().callRenameFolderWebService(folderObject.folderId, securityToken: securityToken!, parameter: folderRenameDictionary) { (json:JSON) in
                        print("folder rename",json)
                        self.getFolderList()
                    }
                }
            } else {
                //code for update the folder name
                let textField = alertView.textFieldAtIndex(0)//get alert view textfield
                if(textField?.text?.characters.count != 0) {
                    let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
                    if(securityToken?.characters.count != 0)  {
                        let folderObject = self.folderArray[textField!.tag]
                        let folderRenameDictionary: NSMutableDictionary = NSMutableDictionary()
                        folderRenameDictionary.setValue(textField?.text, forKey: "folderName")
                        WebServiceManager().callRenameFolderWebService(folderObject.folderId, securityToken: securityToken!, parameter: folderRenameDictionary) { (json:JSON) in
                            print("folder rename",json)
                            self.getFolderList()
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.view.makeToast(message: "￼Please enter a folder name.")
                    })
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
