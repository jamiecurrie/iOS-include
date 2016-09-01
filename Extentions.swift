//
//  Extentions.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 25/08/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import UIKit

extension NSDate {
    
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    // this is to get round the int32 behavior in legency device in fucking swift... i love you really swift
    func stupidDateToStringFix(dateString: String) -> NSDate {
        
        let comps = NSDateComponents()
        
        let splitDate = dateString.componentsSeparatedByString(" ")[0]
        
        comps.year = Int(splitDate.componentsSeparatedByString("-")[0])!
        comps.month = Int(splitDate.componentsSeparatedByString("-")[1])!
        comps.day = Int(splitDate.componentsSeparatedByString("-")[2])!
        
        
        let splitTime = dateString.componentsSeparatedByString(" ")[1]
        
        comps.hour = Int(splitTime.componentsSeparatedByString(":")[0])!
        comps.minute = Int(splitTime.componentsSeparatedByString(":")[1])!
        comps.second = Int(splitTime.componentsSeparatedByString(":")[2])!
        
        let cal = NSCalendar.currentCalendar()
        cal.timeZone = NSTimeZone(abbreviation: "UTC")!
        
        if let date: NSDate = cal.dateFromComponents(comps) {
            return date
        } else {
            print("❗️ Couldn't covert to NSDate: \(dateString)")
            ErrorLogger().log(self.dynamicType, funcRef: #function, errorRef: "Couldn't covert to NSDate: \(dateString)")
            return NSDate()
        }
    }
    
    func systemTimeZone() -> String {
        
        let formattor = NSDateFormatter()
        formattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattor.timeZone = NSTimeZone.systemTimeZone()
        
        return formattor.stringFromDate(self)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
