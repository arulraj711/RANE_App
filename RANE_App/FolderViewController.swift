//
//  FolderViewController.swift
//  RANE_App
//
//  Created by cape start on 30/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON

class FolderViewController: UIViewController,UIAlertViewDelegate {
   
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var folderListView: UITableView!
    var folderArray = [FolderObject]()
    var selectedFolderIdArray:NSMutableArray = NSMutableArray()
    var intermediateArray:NSMutableArray = NSMutableArray()
    var unSelectedFolderIdArray:NSMutableArray = NSMutableArray()
    var selectedArticleId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.masksToBounds = true;
        cancelButton.layer.cornerRadius = 6.0;
        
        saveButton.layer.masksToBounds = true;
        saveButton.layer.cornerRadius = 6.0;
        
        self.addRightNavBaritem()
        
        self.getFolderList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addRightNavBaritem() {
        let markedImportantButton = UIButton()
        markedImportantButton.setImage(UIImage(named: "create_folder"), forState: .Normal)
        markedImportantButton.frame = CGRectMake(0, 0, 25, 25)
        markedImportantButton.addTarget(self, action: #selector(FolderViewController.createFolderButtonClick), forControlEvents: .TouchUpInside)
        let markedImportantItem = UIBarButtonItem()
        markedImportantItem.customView = markedImportantButton
        self.navigationItem.rightBarButtonItems = [markedImportantItem]
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
                            
                            for folder in self.folderArray {
                                if(folder.folderArticleIdArray.containsObject(self.selectedArticleId!)) {
                                    self.intermediateArray.addObject(folder.folderId)
                                }
                            }
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
        cell.checkMarkButton.tag = indexPath.row
        if(self.intermediateArray.containsObject(folderObject.folderId)) {
            cell.checkMarkButton.selected = true
        } else {
            cell.checkMarkButton.selected = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let folderObject = self.folderArray[indexPath.row]
        if(self.intermediateArray.containsObject(folderObject.folderId)) {
            self.intermediateArray.removeObject(folderObject.folderId)
            self.unSelectedFolderIdArray.addObject(folderObject.folderId)
        } else {
            self.intermediateArray.addObject(folderObject.folderId)
            self.unSelectedFolderIdArray.removeObject(folderObject.folderId)
            self.selectedFolderIdArray.addObject(folderObject.folderId)
        }
        self.folderListView.reloadData()
    }
    
    
    @IBAction func checkMarkButtonClick(sender: UIButton) {
        let folderObject = self.folderArray[sender.tag]
        if(self.intermediateArray.containsObject(folderObject.folderId)) {
            self.intermediateArray.removeObject(folderObject.folderId)
            self.unSelectedFolderIdArray.addObject(folderObject.folderId)
        } else {
            self.intermediateArray.addObject(folderObject.folderId)
            self.unSelectedFolderIdArray.removeObject(folderObject.folderId)
            self.selectedFolderIdArray.addObject(folderObject.folderId)
        }
        self.folderListView.reloadData()
    }
    
    @IBAction func cancelButtonClick(sender: UIButton) {
        
    }
    @IBAction func saveButtonClick(sender: UIButton) {
        let selectedFolderArray:NSMutableArray = NSMutableArray()
        if(self.selectedFolderIdArray.count != 0) {
            // Add article to folder API
            let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
            if(securityToken?.characters.count != 0)  {
                for folderId in self.selectedFolderIdArray {
                    let addArticleToFolderDic: NSMutableDictionary = NSMutableDictionary()
                    addArticleToFolderDic.setValue(String(folderId), forKey: "id")
                    selectedFolderArray.addObject(addArticleToFolderDic)
                }
                WebServiceManager.sharedInstance.callAddArticleToFolderWebService(self.selectedArticleId!, securityToken: securityToken!, parameter: selectedFolderArray) { (json:JSON) in
                    print("add article response",json)
                }
            }
            
        }
        
        let unSelectedFolderArray:NSMutableArray = NSMutableArray()
        if(self.unSelectedFolderIdArray.count != 0) {
            //Remove article from folder API calling
            let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
            if(securityToken?.characters.count != 0)  {
                for folderId in self.unSelectedFolderIdArray
                
                {
                    let addArticleToFolderDic: NSMutableDictionary = NSMutableDictionary()
                    addArticleToFolderDic.setValue(String(folderId), forKey: "id")
                    unSelectedFolderArray.addObject(addArticleToFolderDic)
                }
                WebServiceManager.sharedInstance.callRemoveArticleFromFolderWebService(self.selectedArticleId!, securityToken: securityToken!, parameter: unSelectedFolderArray) { (json:JSON) in
                    print("remove article response",json)
                }
            }
        }
    }
    
    
    func createFolderButtonClick() {
        let alert = UIAlertView()
        alert.title = "Create Folder"
        alert.addButtonWithTitle("Cancel")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.addButtonWithTitle("Save")
        alert.delegate = self
        alert.show()
        
        
        let textField = alert.textFieldAtIndex(0)
        textField?.placeholder = "Folder name"
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("button index",buttonIndex)
        if(buttonIndex == 1) {
            let textField = alertView.textFieldAtIndex(0)//get alert view textfield
            if(textField?.text?.characters.count != 0) {
                let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
                if(securityToken?.characters.count != 0)  {
                    let createFolderDic: NSMutableDictionary = NSMutableDictionary()
                    createFolderDic.setValue(textField?.text, forKey: "folderName")
                    WebServiceManager.sharedInstance.callCreateFolderWebService(securityToken!, parameter: createFolderDic) { (json:JSON) in
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "Folder created.")
                            self.getFolderList()
                        })
                    }
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.view.makeToast(message: "￼Please enter a folder name.")
                })
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
