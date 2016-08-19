//
//  CustomListCell.swift
//  RANE_App
//
//  Created by cape start on 11/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit

class CustomListCell: UITableViewCell {

    @IBOutlet var articleTitle: UILabel!
    @IBOutlet weak var fieldNameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var fieldName: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var outletName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
