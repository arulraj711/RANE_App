//
//  DetailViewCell.swift
//  RANE_App
//
//  Created by cape start on 24/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class DetailViewCell: UICollectionViewCell {
    @IBOutlet var fieldsNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet var readFullArticleButton: UIButton!
    @IBOutlet var webviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var articlePublishedDateLabel: UILabel!
    @IBOutlet var articleDetailWebView: UIWebView!
    @IBOutlet var articleContactLabel: UILabel!
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var articleFieldNamelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
