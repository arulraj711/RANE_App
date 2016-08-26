//
//  CommentObject.swift
//  RANE_App
//
//  Created by cape start on 26/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentObject {
    var commentId:String!
    var username:String!
    var photoUrl:String!
    var createdDate:String!
    var comment:String!
    required init(json: JSON) {
        commentId = json["id"].stringValue
        username = json["userName"].stringValue
        photoUrl = json["photoUrl"].stringValue
        createdDate = json["createdDate"].stringValue
        comment = json["comment"].stringValue
    }
    
}