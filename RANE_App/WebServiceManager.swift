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

    static let sharedInstance = WebServiceManager()
    
    let baseURL = "http://fullintel.com/3.1.0/api/v1/userauthentication"
    
    func getRandomUser(parameter: NSMutableDictionary,onCompletion: (JSON) -> Void) {
        let route = baseURL
        WebService().makeHTTPPostRequest(route, body: parameter, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
        
        
    }
}
