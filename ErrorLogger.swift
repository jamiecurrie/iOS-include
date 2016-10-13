//
//  ErrorLogger.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 21/07/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import Foundation

class ErrorLogger {
    
    var session = URLSession.shared
    let endpoint = URL(string: "https://bigdogcloud.co.uk/api/ios/errorlogger.php")
    let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    
    
    // Call like this -> ErrorLogger().log(self.dynamicType, funcRef: #function, errorRef: "\(error)")
    func log(_ classRef: AnyClass, funcRef: String, errorRef: String) {
        
        let logMessage = "App:\n         - \(appName)\n\nClass:\n         - \(classRef)\n\nFunction:\n         - \(funcRef)\n\nError:\n         - \(errorRef)"
        
        let request = NSMutableURLRequest()
        request.url = endpoint
        request.httpMethod = "POST"
        let postString = "app=\(appName)&log=\(logMessage)"
        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                print("🚨 ErrorLogger: \(error)")
            } else {
                if let stringData = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print("🚨 ErrorLogger: \(stringData)")
                }
            }
        }) 
        
        task.resume()
    }
}
