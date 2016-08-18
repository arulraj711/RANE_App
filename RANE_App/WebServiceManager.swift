//
//  WebServiceManager.swift
//  RANE_App
//
//  Created by cape start on 12/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import UIKit
import SwiftyJSON

class WebServiceManager: NSObject {
    var menuItems = [MenuObject]()
    static let sharedInstance = WebServiceManager()
    
    
    
    func callLoginWebService(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        let loginAPIFunctionName = "userauthentication"
        WebService().makeHTTPPostRequest(loginAPIFunctionName, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
            if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("securityToken") {
                
                self.callMenuWebService(myLoadedString) { (json:JSON) in }
            }
        })
    }
    
    
    func callMenuWebService(securityToken:String,onCompletion: (JSON) -> Void) {
        //customer/menu?security_token=422ee02ea949e35df708c660a5d59ada28a26ff3
        let menuAPIFunctionName = "customer/menu?security_token="+securityToken
        WebService().makeHTTPGetRequest(menuAPIFunctionName, onCompletion: { json, err in
            
            print("menu response-->",json)
            self.menuItems.removeAll()
            if let results = json.array {
                for entry in results {
                    self.menuItems.append(MenuObject(json: entry))
                    //self.loginInputDictionary.setValue(self.items, forKey: "email")
                }
                
            }
            
            onCompletion(json as JSON)
        })
    }
    
    
    func callDailyDigestArticleListWebService(dailyDigestId:Int,securityToken:String,page:Int,size:Int,onCompletion: (JSON) -> Void) {
        //client/newsletter/2099/articles?security_token=559726fb5cb73933cb5da372d8e1b99df1dc3b38&page=0&size=10
        
        
        //let test = "client/newsletter/0/articles?security_token="+securityToken+"&page="+page
        
        let dailyDigestAPIFunctionName = "client/newsletter/"+String(dailyDigestId)+"/articles?security_token="+securityToken+"&page="+String(page)+"&size="+String(size)
        print(dailyDigestAPIFunctionName)
        
        WebService().makeHTTPGetRequest(dailyDigestAPIFunctionName, onCompletion: { json, err in
            onCompletion(json as JSON)
            
        })
        
        
    }
    
}
