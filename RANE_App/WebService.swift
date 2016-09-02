//
//  WebService.swift
//  RANE_App
//
//  Created by CapeStart Apple on 8/5/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void



class WebService: NSObject {
    
    
//    func getBaseURL() -> String {
//        var myDict: NSDictionary?
//        
//        
//        
//        if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
//            myDict = NSDictionary(contentsOfFile: path)
//        }
//        print(myDict)
//        print(myDict!["Base_Url"])
//        
//        let baseURLString:String = myDict!["Base_Url"] as! String
//        print("test baseURL function")
//        return baseURLString
//    }
//    
//    func mySimpleFunction() {
//        print("mySimpleFunction is called");
//    }
    
    static let sharedInstance = WebService()
    
    let baseURL = "http://stageapi.fullintel.com/3.5.1/"
    
    // MARK: Perform a GET Request
    func makeHTTPGetRequest(functionName: String, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        print("get request--->",request)
        let session = NSURLSession.sharedSession()
        if(Reachability.isConnectedToNetwork()) {
           // self.showProgressView() //show progressview
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                    self.hideProgressView() //hide progressview
                    let statusCode = httpResponse.statusCode
                    if(statusCode == 200) {
                        //success block
                        if let jsonData = data {
                            let json:JSON = JSON(data: jsonData)
                            onCompletion(json, nil)
                        } else {
                            onCompletion(nil, error)
                        }
                    } else {
                        //failure block
                        if let jsonData = data {
                            let json:JSON = JSON(data: jsonData)
                            print("failure json",json)
                            if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
                                dispatch_async(dispatch_get_main_queue(),{
                                    window.makeToast(message: json["message"].stringValue)
                                    if(json["statusCode"].intValue == 401) {
                                        NSNotificationCenter.defaultCenter().postNotificationName("SessionExpired", object: nil)
                                    }
                                })
                            }
                        }
                    }
                }
            })
            task.resume()
        } else {
            self.showNoNetworkErrorMessage()
        }
    }
    
    // MARK: Perform a POST Request
    func makeHTTPPostRequest(functionName: String, body: NSMutableDictionary, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        // Set the method to POST
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("request--->",request)
        
        if(Reachability.isConnectedToNetwork()) {
            self.showProgressView() //show progressview
            do {
                // Set the POST body for the request
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                print("request body--->",body);
                request.HTTPBody = jsonBody
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                        self.hideProgressView() //hide progressview
                        let statusCode = httpResponse.statusCode
                        if(statusCode == 200 || statusCode == 201) {
                            //success block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                //print("error json",json)
                                onCompletion(json, nil)
                            } else {
                                onCompletion(nil, error)
                            }
                        } else {
                            //failure block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                print("failure json",json)
                                if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
                                    dispatch_async(dispatch_get_main_queue(),{
                                        window.makeToast(message: json["message"].stringValue)
                                        if(json["statusCode"].intValue == 401) {
                                            NSNotificationCenter.defaultCenter().postNotificationName("SessionExpired", object: nil)
                                        }
                                    })
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                })
                task.resume()
            } catch {
                // Create your personal error
                onCompletion(nil, nil)
            }
        } else {
            self.showNoNetworkErrorMessage()
        }
    }
    
    
    // MARK: Perform a POST Request
    func makeHTTPPostForFolderRequest(functionName: String, body: NSMutableArray, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        // Set the method to POST
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("request--->",request)
        
        if(Reachability.isConnectedToNetwork()) {
            self.showProgressView() //show progressview
            do {
                // Set the POST body for the request
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                print("request body--->",body);
                request.HTTPBody = jsonBody
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                        self.hideProgressView() //hide progressview
                        let statusCode = httpResponse.statusCode
                        if(statusCode == 200) {
                            //success block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                //print("error json",json)
                                onCompletion(json, nil)
                            } else {
                                onCompletion(nil, error)
                            }
                        } else {
                            //failure block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                print("failure json",json)
                                if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
                                    dispatch_async(dispatch_get_main_queue(),{
                                        window.makeToast(message: json["message"].stringValue)
                                        if(json["statusCode"].intValue == 401) {
                                            NSNotificationCenter.defaultCenter().postNotificationName("SessionExpired", object: nil)
                                        }
                                    })
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                })
                task.resume()
            } catch {
                // Create your personal error
                onCompletion(nil, nil)
            }
        } else {
            self.showNoNetworkErrorMessage()
        }
    }
    
    // MARK: Perform a PUT Request
    func makeHTTPPutRequest(functionName: String, body: NSMutableDictionary, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        // Set the method to POST
        request.HTTPMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("request--->",request)
        
        if(Reachability.isConnectedToNetwork()) {
            self.showProgressView() //show progressview
            do {
                // Set the POST body for the request
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                print("request body--->",body);
                request.HTTPBody = jsonBody
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                        self.hideProgressView() //hide progressview
                        let statusCode = httpResponse.statusCode
                        if(statusCode == 200) {
                            //success block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                //print("error json",json)
                                onCompletion(json, nil)
                            } else {
                                onCompletion(nil, error)
                            }
                        } else {
                            //failure block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                print("failure json",json)
                                if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
                                    dispatch_async(dispatch_get_main_queue(),{
                                        window.makeToast(message: json["message"].stringValue)
                                        if(json["statusCode"].intValue == 401) {
                                            NSNotificationCenter.defaultCenter().postNotificationName("SessionExpired", object: nil)
                                        }
                                    })
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                })
                task.resume()
            } catch {
                // Create your personal error
                onCompletion(nil, nil)
            }
        } else {
            self.showNoNetworkErrorMessage()
        }
    }
    
    
    
    
    
    // MARK: Perform a Delete Request
    func makeHTTPDeleteRequest(functionName: String, body: NSMutableArray, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        // Set the method to POST
        request.HTTPMethod = "DELETE"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("request--->",request)
        
        if(Reachability.isConnectedToNetwork()) {
            self.showProgressView() //show progressview
            do {
                // Set the POST body for the request
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                print("request body--->",body);
                request.HTTPBody = jsonBody
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                        self.hideProgressView() //hide progressview
                        let statusCode = httpResponse.statusCode
                        if(statusCode == 200) {
                            //success block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                //print("error json",json)
                                onCompletion(json, nil)
                            } else {
                                onCompletion(nil, error)
                            }
                        } else {
                            //failure block
                            if let jsonData = data {
                                let json:JSON = JSON(data: jsonData)
                                print("failure json",json)
                                if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
                                    dispatch_async(dispatch_get_main_queue(),{
                                        window.makeToast(message: json["message"].stringValue)
                                        if(json["statusCode"].intValue == 401) {
                                            NSNotificationCenter.defaultCenter().postNotificationName("SessionExpired", object: nil)
                                        }
                                    })
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                })
                task.resume()
            } catch {
                // Create your personal error
                onCompletion(nil, nil)
            }
        } else {
            self.showNoNetworkErrorMessage()
        }
    }
    
    func showNoNetworkErrorMessage() {
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            dispatch_async(dispatch_get_main_queue(),{
                window.makeToast(message: "Please check your network connection")
            })
        }
    }
    
    func showProgressView() {
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            dispatch_async(dispatch_get_main_queue(),{
                window.makeToastActivity()
            })
        }
    }
    
    func hideProgressView() {
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            dispatch_async(dispatch_get_main_queue(),{
                window.hideToastActivity()
            })
        }
    }
}
    
