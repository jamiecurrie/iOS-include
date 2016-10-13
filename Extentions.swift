//
//  Extentions.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 25/08/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension UILabel{
    
    func autoAdjustForTextHeight() {
        
        // create new label to get height
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        self.sizeThatFits(CGSize(width: self.frame.width, height: label.frame.height))
    }
}

extension URLRequest {
    
    func getQueryDictionary() -> NSDictionary {
        
        let params = NSMutableDictionary()
        
        if let query = (self.url?.query) {
            let items = query.components(separatedBy: "&")
            
            for item in items {
                let elts = item.components(separatedBy: "=")
                params.setValue(elts.last!, forKey: elts.first!)
            }
        }
        return params
    }
}

extension Date {
    
    func numberOfDaysUntilDateTime(toDateTime: Date) -> Int {
        
        let calendar = Calendar.current
        
        let fromDate = calendar.startOfDay(for: self)
        let toDate = calendar.startOfDay(for: toDateTime)
        
        let difference = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return difference.day!
    }
    
    
    // this is to get round the int32 behavior in legency device in fucking swift... i love you really swift
    func stupidDateToStringFix(_ dateString: String) -> Date {
        
        var comps = DateComponents()
        
        let splitDate = dateString.components(separatedBy: " ")[0]
        
        comps.year = Int(splitDate.components(separatedBy: "-")[0])!
        comps.month = Int(splitDate.components(separatedBy: "-")[1])!
        comps.day = Int(splitDate.components(separatedBy: "-")[2])!
        
        
        let splitTime = dateString.components(separatedBy: " ")[1]
        
        comps.hour = Int(splitTime.components(separatedBy: ":")[0])!
        comps.minute = Int(splitTime.components(separatedBy: ":")[1])!
        comps.second = Int(splitTime.components(separatedBy: ":")[2])!
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        
        if let date: Date = cal.date(from: comps) {
            return date
        } else {
            print("❗️ Couldn't covert to NSDate: \(dateString)")
            ErrorLogger().log(type(of: self) as! AnyClass, funcRef: #function, errorRef: "Couldn't covert to NSDate: \(dateString)")
            return Date()
        }
    }
    
    func systemTimeZone() -> String {
        
        let formattor = DateFormatter()
        formattor.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formattor.timeZone = TimeZone.current
        
        return formattor.string(from: self)
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

extension Data {
    
    
    func getDictionaryFromJsonData () -> NSDictionary {
        if let parsedObject: AnyObject? = try! JSONSerialization.jsonObject(with: self, options: []) as AnyObject?? {
            if let dictionary = parsedObject as? NSDictionary {
                
                return dictionary
            } else {
                print("📂 <\(#function)> ERROR: Unable to parse as dictionay")
            }
        } else {
            print("📂 <\(#function)> ERROR: NSJSONSerialization failed")
        }
        return [:]
    }
    
}
