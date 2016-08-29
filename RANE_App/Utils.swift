//
//  Utils.swift
//  RANE_App
//
//  Created by cape start on 22/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation

public class Utils {
    class func convertTimeStampToDate(timestamp:Double) -> String {
        let date = NSDate(timeIntervalSince1970:timestamp/1000)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    class func convertTimeStampToDrillDateModel(timestamp:Double) -> String {
        let date = NSDate(timeIntervalSince1970:timestamp/1000)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return ""
        } else {
            return value
        }
    }
    
}