//
//  ErrorLogger.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 21/07/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import Foundation

class ErrorLogger {
    
    var session = NSURLSession.sharedSession()
    let endpoint = NSURL(string: "https://bigdogcloud.co.uk/api/ios/errorlogger.php")
    let appName = "Rolls-Royce"
    
    
    // Call like this -> ErrorLogger().log(self.dynamicType, funcRef: #function, errorRef: "\(error)")
    func log(classRef: AnyClass, funcRef: String, errorRef: String) {
        
        let logMessage = "<CLASS> \(classRef)\n<FUNCTION> \(funcRef)\n<ERROR> \(errorRef)"
        print("🚨 ErrorLogger:\n\(logMessage)")
        
        let request = NSMutableURLRequest()
        request.URL = endpoint
        request.HTTPMethod = "POST"
        let postString = "app=\(appName)&log=\(logMessage)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if (error != nil) {
                print("🚨 ErrorLogger: \(error)")
            } else {
                if let stringData = NSString.init(data: data!, encoding: NSUTF8StringEncoding) {
                    print("🚨 ErrorLogger: \(stringData)")
                }
            }
        }
        
        task.resume()
    }
}
