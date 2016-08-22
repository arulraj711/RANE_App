//
//  ArticleObject.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/18/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

class ArticleObject {
    var articleId:String!
    var articleDescription:String!
    var articleURL:String!
    var articleTitle:String!
    var articleTypeId:Int!
    var companyId:Int!
    var fieldsName:String = ""
    var outletName:String = ""
    var articlepublishedDate:Double!
    
    required init(json: JSON) {
        articleId = json["id"].stringValue
        articleDescription = json["articleDescription"].stringValue
        articleURL = json["articleURL"].stringValue
        articleTitle = json["heading"].stringValue
        //articleTypeIdArray = json["articleTypeId"].array.[0]
        articleTypeId = json["articleTypeId"][0].intValue
        companyId = json["companyId"].intValue
        articlepublishedDate = json["publishedDate"].doubleValue
        /* fields name configuration */
        if let fieldsArray = json["fields"].array {
            for fields in fieldsArray {
                if(fieldsName.characters.count == 0) {
                    fieldsName = fieldsName.uppercaseString+fields["name"].stringValue.uppercaseString
                } else {
                    fieldsName = fieldsName.uppercaseString+" & "+fields["name"].stringValue.uppercaseString
                }
                
            }
        }
        
        /* outlet name configuration */
        if let outletArray = json["outlet"].array {
            for outlet in outletArray {
                if(outletName.characters.count == 0) {
                    outletName = outletName.uppercaseString+outlet["name"].stringValue.uppercaseString
                } else {
                    outletName = outletName.uppercaseString+" & "+outlet["name"].stringValue.uppercaseString
                }
                
            }
        }
    }
}