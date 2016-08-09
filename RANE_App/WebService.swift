//
//  WebService.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/5/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import Alamofire


class WebService: NSObject {
    
    
    
    
    func mySimpleFunction() {
        print("mySimpleFunction is called");
    }
    
    
    func loginWebServiceCall() {
        
        
//        Alamofire.request(<#T##URLRequest: URLRequestConvertible##URLRequestConvertible#>)
//        
//        Alamofire.request(<#T##method: Method##Method#>, <#T##URLString: URLStringConvertible##URLStringConvertible#>)
//        
//        Alamofire.request(<#T##method: Method##Method#>, <#T##URLString: URLStringConvertible##URLStringConvertible#>, parameters: <#T##[String : AnyObject]?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##[String : String]?#>)
        
        Alamofire.request(.POST, "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate", parameters: ["password" : "Welcome0804!",
            "email" : "kristine.eissing@ranenetwork.com"])
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
//        let urlString = "http://example.com/file.php"
//        let dictionary = ["key1": [1,2,3], "key2": [2,4,6]]
//        
//        
//        
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        manager.POST(urlString, parameters: dictionary, success:
//            {
//                requestOperation, response in
//                
//                let result = NSString(data: response as! NSData, encoding: NSUTF8StringEncoding)!
//                
//                print(result)
//            },
//                     failure:
//            {
//                requestOperation, error in
//        })
//
//        
//        
//        
//        //let manager = AFHTTPSessionManager(baseURL: NSURL())
//        
////        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "http://frog-api.localhost"))
////        manager.requestSerializer = AFJSONRequestSerializer()
////        manager.responseSerializer = AFJSONResponseSerializer()
////        
////        let params = [
////            "foo": "bar"
////        ]
////
////        
//////        [manager GET:@"http://example.com/resources.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//////            NSLog(@"JSON: %@", responseObject);
//////        } failure:^(NSURLSessionTask *operation, NSError *error) {
//////            NSLog(@"Error: %@", error);
//////        }];
////        
////        
////        manager.POST("/app_dev.php/oauth/v2/token", parameters: params, success: {
////            (task: NSURLSessionDataTask!, responseObject: id) in
////            println("success")
////            
////            }, failure: {
////                (task: NSURLSessionDataTask!, error: NSError!) in
////                println("error")
////        })
    }
    
}