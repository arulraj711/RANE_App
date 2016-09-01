//
//  WebServiceManager.swift
//  RANE_App
//
//  Created by cape start on 12/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class WebServiceManager: NSObject {
    var menuItems = [Menu]()
    
    static let sharedInstance = WebServiceManager()
    
    
    
    func callLoginWebService(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //api/v1/eti/customers/authenticate for RANE live login
        let loginAPIFunctionName = "api/v1/userauthentication"
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            
            let securityToken = NSUserDefaults.standardUserDefaults().stringForKey("securityToken")
            
            if(securityToken?.characters.count != 0) {
                
                self.callMenuWebService(securityToken!) { (json:JSON) in }
            }
        })
    }
    
    
    func callMenuWebService(securityToken:String,onCompletion: (JSON) -> Void) {
        //customer/menu?security_token=422ee02ea949e35df708c660a5d59ada28a26ff3
        let menuAPIFunctionName = "api/v1/customer/menu?security_token="+securityToken
        WebService().makeHTTPGetRequest(menuAPIFunctionName, onCompletion: { json, err in
            
            print("menu response-->",json)
            self.menuItems.removeAll()
            if let results = json.array {
                for entry in results {
//                    print("single entry",entry)
                    if(entry["subscribed"].boolValue == true) {
                        
//                        if(entry["id"].intValue == 9) {
//                            //marked important
//                            continue
//                        } else if(entry["id"].intValue == 6) {
//                            //saved for later
//                            continue
//                        } else {
                        
                       //CoreDataController().updateMenuInfoInCoreData(entry)
                        
                        CoreDataController().addMenu(entry)
                        
                        //}
                    }
                    
                    //self.loginInputDictionary.setValue(self.items, forKey: "email")
                }
                
                
                let contactDictionary = ["id": "101", "name": "Contact RiskDesk"]
                let contactJSONObj = JSON(contactDictionary)
                CoreDataController().addMenu(contactJSONObj)
//                CoreDataController().updateMenuInfoInCoreData(contactJSONObj)
//                //self.menuItems.append(MenuObject(json: contactJSONObj))
//                
//                
                let logoutDictionary = ["id": "102", "name": "Logout"]
                let logoutJSONObj = JSON(logoutDictionary)
                CoreDataController().addMenu(logoutJSONObj)
//                CoreDataController().updateMenuInfoInCoreData(logoutJSONObj)
//               // self.menuItems.append(MenuObject(json: logoutJSONObj))
                self.menuItems = CoreDataController().getEntityInfoFromCoreData("Menu")
            }
            
            onCompletion(json as JSON)
        })
    }
    
    // For newsletter API call
    func callDailyDigestArticleListWebService(dailyDigestId:Int,securityToken:String,page:Int,size:Int,onCompletion: (JSON) -> Void) {
        let dailyDigestAPIFunctionName = "api/v1/client/newsletter/"+String(dailyDigestId)+"/articles?security_token="+securityToken+"&page="+String(page)+"&size="+String(size)
        WebService().makeHTTPGetRequest(dailyDigestAPIFunctionName, onCompletion: { json, err in
            
                if let results = json.array {
                    for entry in results {
                        CoreDataController().addArticle(entry, contentTypeId: 20, pageNo: page,searchText: "")
                        
                    }
                }
            
            onCompletion(json as JSON)
        })
    }
    
    func callArticleListWebService(activityTypeId:Int,securityToken:String,contentTypeId:Int,page:Int,size:Int,searchString:String,onCompletion: (JSON) -> Void) {
        
        //articles?security_token=ab6526b6260000c584e810ccede97ca8111533e9&contentTypeId=1&page=0&size=10
        
        //http://fullintel.com/2.0.0/api/v1/articles/2?security_token=ab6526b6260000c584e810ccede97ca8111533e9&contentTypeId=1&page=0&size=10&query=Google
        
        
        var articleAPIFunctionName:String = ""
        if(searchString.characters.count == 0) {
            
            if(activityTypeId == 0) {
                //for normal articles
                articleAPIFunctionName = "api/v1/articles?security_token="+securityToken+"&contentTypeId="+String(contentTypeId)+"&page="+String(page)+"&size="+String(size)
            } else {
                //for marked important and saved for later articles
                articleAPIFunctionName = "api/v1/articles/"+String(activityTypeId)+"?security_token="+securityToken+"&contentTypeId="+String(contentTypeId)+"&page="+String(page)+"&size="+String(size)
            }
        } else {
            articleAPIFunctionName = "api/v1/articles?security_token="+securityToken+"&page="+String(page)+"&size="+String(size)+"&query="+searchString
        }
        WebService().makeHTTPGetRequest(articleAPIFunctionName, onCompletion: { json, err in
            //if(searchString.characters.count == 0) {
                if let results = json.array {
                    print("results count",results.count)
                    for entry in results {
                        CoreDataController().addArticle(entry, contentTypeId: contentTypeId, pageNo: page,searchText: searchString)
                        
                    }
                }
            //}
            onCompletion(json as JSON)
        })
    }
    
    
    func callUserActivitiesOnArticlesWebService(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //http://fullintel.com/2.0.0/services/mv01/sv00/appuser/useractivitiesonarticles
        let loginAPIFunctionName = "services/mv01/sv00/appuser/useractivitiesonarticles"
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            
            
        })
    }
    
    func callGetCommentsWebService(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //http://fullintel.com/2.0.0/services/mv01/sv00/appuser/useractivitiesonarticles
        let loginAPIFunctionName = "services/mv01/sv00/appuser/useractivity/article/getcomment"
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            
            
        })
    }
    
    func callAddCommentsWebService(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //http://fullintel.com/2.0.0/services/mv01/sv00/appuser/useractivitiesonarticles
        let loginAPIFunctionName = "services/mv01/sv00/appuser/useractivity/article/addcomment"
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            
            
        })
    }
    
    // For newsletter list API call
    func callDailyDigestListWebService(securityToken:String,onCompletion: (JSON) -> Void) {
        //http://fullintel.com/2.0.0/api/v1/client/newsletters?security_token=bae2c2521aeed73cb9428ae52114529f3643350b
        let dailyDigestAPIFunctionName = "api/v1/client/newsletters?security_token="+securityToken
        WebService().makeHTTPGetRequest(dailyDigestAPIFunctionName, onCompletion: { json, err in
            onCompletion(json as JSON)
            
        })
    }
    
    // For folder list API call
    func callFolderListWebService(securityToken:String,onCompletion: (JSON) -> Void) {
        //http://fullintel.com/2.0.0/api/v1/client/newsletters?security_token=bae2c2521aeed73cb9428ae52114529f3643350b
        let dailyDigestAPIFunctionName = "api/v1/folders?security_token="+securityToken
        WebService().makeHTTPGetRequest(dailyDigestAPIFunctionName, onCompletion: { json, err in
            onCompletion(json as JSON)
            
        })
    }
    
    // For folder rename API
    func callRenameFolderWebService(folderId:Int,securityToken:String,parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //api/v1/folders/191?security_token=1b8e7e2e1bb9ca1b74273c3b9a859baa053ab703
        let folderRenameAPIFunctionName = "api/v1/folders/"+String(folderId)+"?security_token="+securityToken
        WebService().makeHTTPPutRequest(folderRenameAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    //Add article to folder
    func callAddArticleToFolderWebService(articleId:String,securityToken:String,parameter: NSMutableArray,onCompletion: (JSON) -> Void) {
        //api/v1/article/4019eb2b-5046-4ef0-9b9d-dc656b5b2a5a/folders?security_token=1b8e7e2e1bb9ca1b74273c3b9a859baa053ab703
        let loginAPIFunctionName = "api/v1/articles/"+articleId+"/folders?security_token="+securityToken
        WebService().makeHTTPPostForFolderRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    //Remove article from folder
    func callRemoveArticleFromFolderWebService(articleId:String,securityToken:String,parameter: NSMutableArray,onCompletion: (JSON) -> Void) {
        //api/v1/article/4019eb2b-5046-4ef0-9b9d-dc656b5b2a5a/folders?security_token=1b8e7e2e1bb9ca1b74273c3b9a859baa053ab703
        let loginAPIFunctionName = "api/v1/articles/"+articleId+"/folders?security_token="+securityToken
        WebService().makeHTTPDeleteRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    func callCreateFolderWebService(securityToken:String,parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        //http://stageapi.fullintel.com/3.5.0/api/v1/folders?isArray=false&security_token=1b8e7e2e1bb9ca1b74273c3b9a859baa053ab703
        let loginAPIFunctionName = "api/v1/folders?isArray=false&security_token="+securityToken
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            
            
        })
    }
    
}
