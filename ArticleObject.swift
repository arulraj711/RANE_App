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
    var articleDetailedDescription:String!
    var articleURL:String!
    var articleTitle:String!
    var articleTypeId:Int!
    var companyId:Int!
    var fieldsName:String = ""
    var outletName:String = ""
    var contactName:String = ""
    var articlepublishedDate:Double!
    var articleModifiedDate:Double!
    
    required init(json: JSON) {
        articleId = json["id"].stringValue
        articleDescription = json["articleDescription"].stringValue
        articleDetailedDescription = json["articleDetailedDescription"].stringValue
        articleURL = json["articleURL"].stringValue
        articleTitle = json["heading"].stringValue
        //articleTypeIdArray = json["articleTypeId"].array.[0]
        articleTypeId = json["articleTypeId"][0].intValue
        companyId = json["companyId"].intValue
        articlepublishedDate = json["publishedDate"].doubleValue
        articleModifiedDate = json["modifiedDate"].doubleValue
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
                    outletName = outletName+outlet["name"].stringValue
                } else {
                    outletName = outletName+" & "+outlet["name"].stringValue
                }
                
            }
        }
        
        /* contact name configuration */
        if let contactArray = json["contact"].array {
            for contact in contactArray {
                if(contactName.characters.count == 0) {
                    contactName = contactName+contact["name"].stringValue
                } else {
                    contactName = contactName+","+contact["name"].stringValue
                }
                
            }
        }
    }
}