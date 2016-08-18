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
    
    let baseURL = "http://stageapi.fullintel.com/3.4.0/api/v1/"
    
    // MARK: Perform a GET Request
    func makeHTTPGetRequest(functionName: String, onCompletion: ServiceResponse) {
        
        let urlString = baseURL+functionName
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        print("get request--->",request)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    
    // MARK: Perform a POST Request
    func makeHTTPPostRequest(functionName: String, body: NSMutableDictionary, onCompletion: ServiceResponse) {
        let urlString = baseURL+functionName
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        // Set the method to POST
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        print("request--->",request)
        do {
            // Set the POST body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            print("request body--->",body);
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if(statusCode == 200) {
                        print("success")
                        if let jsonData = data {
                            let json:JSON = JSON(data: jsonData)
                            onCompletion(json, nil)
                        } else {
                            onCompletion(nil, error)
                        }
                    } else {
                        print("failure")
                    }
                }
                
                
                
            })
            task.resume()
        } catch {
            // Create your personal error
            onCompletion(nil, nil)
        }
    }
    
//    func callPostServiceMethod() {
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate")!)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        
//        let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
//        
//        Alamofire.request(request)
//            .responseJSON { response in
//                print("request--->",response.request)  // original URL request
//                print("response--->",response.response) // URL response
//                print("data--->",response.data)     // server data
//                print("result--->",response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
//    }
//    
//    
//    func callGetServiceMethod() {
//        Alamofire.request(.GET, "http://fullintel.com/3.1.0/api/v1/customer/menu?security_token=dfasfsdfgfdgdfghd", parameters: nil)
//                    .responseJSON { response in
//                                        print("request--->",response.request)  // original URL request
//                                        print("response--->",response.response) // URL response
//                                        print("data--->",response.data)     // server data
//                                        print("result--->",response.result)   // result of response serialization
//        
//                                        if let JSON = response.result.value {
//                                            print("JSON: \(JSON)")
//                                        }
//                                    }
//    }
//    
//    
//    
//    func loginWebService(functionName: String, parameters:NSDictionary){
//        let urlString = getBaseURL()+functionName
//        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
//        print("before API Call",urlString)
//        var json: NSDictionary?
////        Alamofire.request(request)
////            .responseJSON { response in
////                print("response")
////                print(response)
////                print("request--->",response.request)  // original URL request
////                print("response--->",response.response) // URL response
////                print("data--->",response.data)     // server data
////                print("result--->",response.result)   // result of response serialization
////                
//////                if let JSON = response.result.value {
//////                    print("JSON: \(JSON)")
//////                }
////                print("before assigning",response.result.value)
//////                JSON = response.result.value
//////                print("result",JSON)
////                
////                
////                
////                do {
////                    json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? NSDictionary
////                } catch {
////                    print(error)
////                }
////                print("inside block",json)
////                
////                
////                
////        }
//       print("result",Alamofire.request(request).response)
//        print("response JSON",Alamofire.request(request).responseJSON(completionHandler: reponse))
//    }
//    
//    func loginWebServiceCall() {
//        
//        
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: getBaseURL())!)
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.HTTPMethod = "POST"
//        
//        let dictionary = ["email": "arul.raj@capestart.com", "password": "start"]
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
//
//        Alamofire.request(request)
//                    .responseJSON { response in
//                        print("request--->",response.request)  // original URL request
//                        print("response--->",response.response) // URL response
//                        print("data--->",response.data)     // server data
//                        print("result--->",response.result)   // result of response serialization
//        
//                        if let JSON = response.result.value {
//                            print("JSON: \(JSON)")
//                        }
//                }
  
        /* Test Webservice
//        let request = NSMutableURLRequest(URL: NSURL(string: ""http://fullintel.com/3.1.0/api/v1/userauthentication)!)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let postString = "id=13&name=Jack"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
//            guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("responseString = \(responseString)")
//        }
//        task.resume()

        
        
        
//        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:nil)
//        
//        let results = NSString(data:reply!, encoding:NSUTF8StringEncoding)
//        println("API Response: \(results)")
        
        
        
        
      //  Alamofire.request(URLRequestConvertible)
        
//        let urlString = "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate"
//        let url = NSURL(string: urlString)
//        let URLRequest = NSMutableURLRequest(URL: url!)
//        
//        URLRequest.HTTPMethod = "POST"
//        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        URLRequest.timeoutInterval = NSTimeInterval(10 * 1000)
//        //URLRequest.HTTPBody =
//        
// 
//        Alamofire.request(URLRequest)
//            .responseJSON { response in
//                print("request--->",response.request)  // original URL request
//                print("response--->",response.response) // URL response
//                print("data--->",response.data)     // server data
//                print("result--->",response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
        
        
//        Alamofire.request(.GET, "http://fullintel.com/3.1.0/api/v1/customer/menu?security_token=dfasfsdfgfdgdfghd", parameters: nil)
//            .responseJSON { response in
//                                print("request--->",response.request)  // original URL request
//                                print("response--->",response.response) // URL response
//                                print("data--->",response.data)     // server data
//                                print("result--->",response.result)   // result of response serialization
//                
//                                if let JSON = response.result.value {
//                                    print("JSON: \(JSON)")
//                                }
//                            }
        
//        let urlString = "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate"
//        if let url = NSURL(string: urlString) {
//            let URLRequest = NSMutableURLRequest(URL: url)
//            URLRequest.setValue("MY_API_KEY", forHTTPHeaderField: "X-Mashape-Key")
//            URLRequest.HTTPMethod = "POST"
//            let bodyData = "key1=value&key2=value&key3=value"
//            URLRequest.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//
//            print("request-->",URLRequest);
//            Alamofire.request(URLRequest)
//            .responseJSON { response in
//                print("request--->",response.request)  // original URL request
//                print("response--->",response.response) // URL response
//                print("data--->",response.data)     // server data
//                print("result--->",response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//            }
//
//        }
        
        
//        Alamofire.request(.POST, "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate", parameters: ["password" : "Welcome0804!",
//            "email" : "kristine.eissing@ranenetwork.com"])
//            .responseJSON { response in
//                print("request--->",response.request)  // original URL request
//                print("response--->",response.response) // URL response
//                print("data--->",response.data)     // server data
//                print("result--->",response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
        
        
        
//        Alamofire.request(<#T##URLRequest: URLRequestConvertible##URLRequestConvertible#>)
//        
//        Alamofire.request(<#T##method: Method##Method#>, <#T##URLString: URLStringConvertible##URLStringConvertible#>)
//        
//        Alamofire.request(<#T##method: Method##Method#>, <#T##URLString: URLStringConvertible##URLStringConvertible#>, parameters: <#T##[String : AnyObject]?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##[String : String]?#>)
        
        
//        Alamofire.request(.POST, "http://fullintel.com/3.1.0/api/v1/eti/customers/authenticate")
//            .validate(contentType: ["application/json"])
//            .responseJSON { response in
//            switch response.result {
//            case .Success:
//                print("Validation Successful")
//            case .Failure(let error):
//                print(error)
//            }
//        }
        
        
//        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    print("Validation Successful")
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//
//        
//        let parameters = [
//            "foo": "bar",
//            "baz": ["a", 1],
//            "qux": [
//                "x": 1,
//                "y": 2,
//                "z": 3
//            ]
//        ]
//        
//        Alamofire.request(.POST, "https://httpbin.org/post", parameters: parameters).responseJSON(completionHandler: <#T##Response<AnyObject, NSError> -> Void#>)
        
//        Alamofire.Manager.sharedInstance.session.configuration
//            .HTTPAdditionalHeaders?.updateValue("application/json",
//                                                forKey: "Content-Type")
//        
        
        
//       Alamofire.request(.POST, "http://httpbin.org/get", parameters: ["foo": "bar"], encoding: Alamofire.ParameterEncoding.URL)
//        .responseJSON { response in
//                            print("request--->",response.request)  // original URL request
//                            print("response--->",response.response) // URL response
//                            print("data--->",response.data)     // server data
//                            print("result--->",response.result)   // result of response serialization
//            
//                            if let JSON = response.result.value {
//                                print("JSON: \(JSON)")
//                            }
//                    }
        
        
        
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
////        })*/
    }
    
