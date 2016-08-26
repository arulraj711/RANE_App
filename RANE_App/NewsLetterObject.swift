//
//  NewsLetterObject.swift
//  RANE_App
//
//  Created by cape start on 26/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsLetterObject {
    var newsletterId:Int!
    var newsletterName:String!
    var newsletterarticleCount:Int!
    
    required init(json: JSON) {
        newsletterId = json["id"].intValue
        newsletterName = json["newsLetterSubject"].stringValue
        
        if let newsletterArticleArray = json["newsletterArticles"].array {
            newsletterarticleCount = newsletterArticleArray.count
        }
        
        
        
    }
    
}