//
//  CustomCommentCell.swift
//  RANE_App
//
//  Created by cape start on 26/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class CustomCommentCell: UITableViewCell {

    @IBOutlet var comment: UILabel!
    @IBOutlet var commentDate: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
