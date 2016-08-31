//
//  CommentsViewController.swift
//  RANE_App
//
//  Created by cape start on 26/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import GrowingTextView

class CommentsViewController: UIViewController,GrowingTextViewDelegate {
    @IBOutlet var commentsOuterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var commentsTextView: UITextView!

    @IBOutlet var commentsOuterView: UIView!
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet var commentsBottomViewConstraint: NSLayoutConstraint!
    var articleId:String=""
    var commentsArray = [CommentObject]()
    let textView = GrowingTextView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.commentsOuterView.layer.borderWidth = 0.5
        self.commentsOuterView.layer.borderColor = UIColor.init(colorLiteralRed: 199/255, green: 199/255, blue: 205/255, alpha: 1).CGColor
        
        
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        self.commentsTableView.estimatedRowHeight = 80
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        print("textview frame",self.commentsTextView.frame)
        textView.frame = CGRectMake(self.commentsTextView.frame.origin.x, self.commentsTextView.frame.origin.y, self.view.frame.size.width-95, 100)
        textView.maxLength = 256
        textView.trimWhiteSpaceWhenEndEditing = false
        textView.placeHolder = "Please enter your comments"
        textView.font = UIFont(name:"OpenSans", size: 14)
        textView.placeHolderColor = UIColor(white: 0.8, alpha: 1.0)
        textView.maxHeight = 100.0
        textView.delegate = self
        self.commentsOuterView.addSubview(textView)
        commentsTextView.backgroundColor = UIColor.whiteColor()
        commentsTextView.layer.cornerRadius = 4.0
        
        
        self.getComment()
        
    }

    
    func getComment() {
        let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
        if(securityToken?.characters.count != 0)  {
            let getCommentInputDictionary: NSMutableDictionary = NSMutableDictionary()
            getCommentInputDictionary.setValue(self.articleId, forKey: "articleId")
            getCommentInputDictionary.setValue(NSUserDefaults.standardUserDefaults().integerForKey("userId"), forKey: "userId")
            getCommentInputDictionary.setValue(securityToken, forKey: "securityToken")
            getCommentInputDictionary.setValue(NSUserDefaults.standardUserDefaults().integerForKey("companyId"), forKey: "customerId")
            getCommentInputDictionary.setValue("1", forKey: "version")
            
            WebServiceManager.sharedInstance.callGetCommentsWebService(getCommentInputDictionary) { (json:JSON) in
                if let results = json["commentList"].array {
                    self.commentsArray.removeAll()
                    if(results.count != 0) {
                        for entry in results {
                            self.commentsArray.append(CommentObject(json: entry))
                        }
                        //self.testGroup(self.articles)
                        dispatch_async(dispatch_get_main_queue(),{
                            //self.tableView.reloadData()
                            self.commentsTableView.reloadData()
                        })
                    } else {
                        //handle empty article list
                        dispatch_async(dispatch_get_main_queue(),{
                            self.view.makeToast(message: "No comments to display")
                        })
                    }
                    
                } else {
                    
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.commentTextField.resignFirstResponder()
        return false
    }
    
    func textViewDidChangeHeight(height: CGFloat) {
        print("new line height",height)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.commentsOuterViewHeightConstraint.constant = height+16
            self.commentsOuterView.layoutIfNeeded()
        }
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        print("before setting view bottom constraint",self.commentsBottomViewConstraint.constant)
        //UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.commentsBottomViewConstraint.constant = keyboardFrame.size.height
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        //})
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
       // UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.commentsBottomViewConstraint.constant = 0
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
        //})
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCommentCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let commentObject = self.commentsArray[indexPath.row]
        cell.username.text = commentObject.username
        cell.comment.sizeToFit()
        cell.comment.text = commentObject.comment
        cell.userImage.layer.masksToBounds = true;
        cell.userImage.layer.cornerRadius = 22.0;
        cell.userImage.kf_setImageWithURL(NSURL(string:commentObject.photoUrl)!, placeholderImage: UIImage(named: "person_placeholder"))
        
        return cell
    }
    
    @IBAction func postCommentButtonClick(sender: UIButton) {
        if(textView.text?.characters.count != 0) {
            let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
            if(securityToken?.characters.count != 0)  {
                let getCommentInputDictionary: NSMutableDictionary = NSMutableDictionary()
                getCommentInputDictionary.setValue(self.articleId, forKey: "articleId")
                getCommentInputDictionary.setValue(NSUserDefaults.standardUserDefaults().integerForKey("userId"), forKey: "userId")
                getCommentInputDictionary.setValue(securityToken, forKey: "securityToken")
                getCommentInputDictionary.setValue(NSUserDefaults.standardUserDefaults().integerForKey("companyId"), forKey: "customerId")
                getCommentInputDictionary.setValue("1", forKey: "version")
                getCommentInputDictionary.setValue("-1", forKey: "parentId")
                getCommentInputDictionary.setValue(textView.text, forKey: "comment")
                WebServiceManager.sharedInstance.callAddCommentsWebService(getCommentInputDictionary) { (json:JSON) in
                    dispatch_async(dispatch_get_main_queue(),{
                        self.textView.text = ""
                        self.getComment()
                    })
                    
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(),{
                self.view.makeToast(message: "Please enter a comment.")
            })
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
