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
        dataDict["title"] = cellArticleObject.articleTitle
        dataDict["Description"] = cellArticleObject.articleDescription
         NSNotificationCenter.defaultCenter().postNotificationName("MailButtonClick", object:self, userInfo:dataDict)
    }
    @IBOutlet var mailButton: UIButton!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet weak var fieldNameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var fieldName: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var outletName: UILabel!
    var cellArticleObject:ArticleObject!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
