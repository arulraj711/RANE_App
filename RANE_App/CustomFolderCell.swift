//
//  CustomFolderCell.swift
//  RANE_App
//
//  Created by cape start on 30/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class CustomFolderCell: UITableViewCell {
    @IBOutlet var checkMarkButton: UIButton!
    @IBOutlet var folderTitle: UILabel!
//    @IBOutlet var editButon: UIButton!
//    @IBOutlet var deleteButton: UIButton!
//    @IBOutlet var rssButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
