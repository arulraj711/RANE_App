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
        print("date conversion",date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        print("Dateobj:",dateString)
        return dateString
    }
    
    class func convertTimeStampToDrillDateModel(timestamp:Double) -> String {
        let date = NSDate(timeIntervalSince1970:timestamp/1000)
        print("date conversion",date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        print("Dateobj:",dateString)
        return dateString
    }
    
}