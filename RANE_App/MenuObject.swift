//
//  MenuObject.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/18/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

class MenuObject {
    var menuId: Int!
    var menuName: String!
    var menuIconURL: String!
    var companyId: Int!
    
    required init(json: JSON) {
        menuId = json["id"].intValue
        menuName = json["name"].stringValue.capitalizedString
        menuIconURL = json["iconUrl"].stringValue
        companyId = json["companyId"].intValue
    }
}
