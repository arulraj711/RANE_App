//
//  CustomListCell.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class CustomListCell: UITableViewCell {

    @IBOutlet var markedImportantButton: UIButton!
    @IBOutlet var savedForLaterButton: UIButton!
    @IBAction func mailButtonClick(sender: UIButton) {
        
        var dataDict = Dictionary<String, String>()
        dataDict["title"] = cellArticleObject.articleTitle!
        dataDict["Description"] = cellArticleObject.articleDescription!
        dataDict["articleUrl"] = cellArticleObject.articleURL!
         NSNotificationCenter.defaultCenter().postNotificationName("MailButtonClick", object:self, userInfo:dataDict)
    }
    @IBOutlet var mailButton: UIButton!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet weak var fieldNameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var fieldName: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var outletName: UILabel!
    var cellArticleObject:Article!
    var cellSection:Int!
    var cellRow:Int!
    var contentTypeId:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func savedForLaterButtonClick(sender: UIButton) {
        var dataDict = Dictionary<String, String>()
        dataDict["title"] = cellArticleObject.articleTitle!
        dataDict["articleId"] = cellArticleObject.articleId
        dataDict["cellSection"] = String(self.cellSection)
        dataDict["cellRow"] = String(self.cellRow)
        dataDict["contentTypeId"] = String(self.contentTypeId)
        dataDict["isSaved"] = String(cellArticleObject.isSavedForLater)
        NSNotificationCenter.defaultCenter().postNotificationName("SavedForLaterButtonClick", object:self, userInfo:dataDict)
    }
    @IBAction func markedImportantButtonClick(sender: UIButton) {
        var dataDict = Dictionary<String, String>()
        dataDict["title"] = cellArticleObject.articleTitle!
        dataDict["articleId"] = cellArticleObject.articleId
        dataDict["cellSection"] = String(self.cellSection)
        dataDict["cellRow"] = String(self.cellRow)
        dataDict["contentTypeId"] = String(self.contentTypeId)
        dataDict["isMarked"] = String(cellArticleObject.isMarkedImportant)
        if(String(cellArticleObject.isMarkedImportant) == "1") {
            if(String(cellArticleObject.markAsImportantUserId) == "0") {
                let loginUserId:Int = NSUserDefaults.standardUserDefaults().integerForKey("userId")
                dataDict["markAsImportantUserId"] = String(loginUserId)
            } else {
                dataDict["markAsImportantUserId"] = String(cellArticleObject.markAsImportantUserId)
            }
            dataDict["markAsImportantUserName"] = String(cellArticleObject.markAsImportantUserName)
        } else {
            let loginUserId:Int = NSUserDefaults.standardUserDefaults().integerForKey("userId")
            dataDict["markAsImportantUserId"] = String(loginUserId)
            dataDict["markAsImportantUserName"] = String("")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("MarkedImportantButtonClick", object:self, userInfo:dataDict)
    }
}
