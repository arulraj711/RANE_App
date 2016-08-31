//
//  FolderObject.swift
//  RANE_App
//
//  Created by cape start on 30/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

class FolderObject {
    var folderId:Int!
    var folderName:String!
    var defaultFlag:Bool
    var rssFeedURL:String!
    var folderArticleIdArray:NSMutableArray = NSMutableArray()
    
    required init(json: JSON) {
        folderId = json["id"].intValue
        folderName = json["folderName"].stringValue
        defaultFlag = json["default"].boolValue
        rssFeedURL = json["rssFeedUrl"].stringValue
        
        /* fields name configuration */
        if let folderArticleArray = json["folderArticles"].array {
            self.folderArticleIdArray.removeAllObjects()
            for folderArticle in folderArticleArray {
                self.folderArticleIdArray.addObject(folderArticle["articleId"].stringValue)
            }
        }
        
    }
    
}