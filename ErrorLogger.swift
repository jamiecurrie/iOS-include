//
//  ErrorLogger.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 21/07/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import Foundation
import UIKit

class ErrorLogger {
    
    var session = URLSession.shared
    let endpoint = URL(string: "https://bigdogcloud.co.uk/api/ios/errorlogger.php")
    let appName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    
    
    /* 
     
     Usage:
     
     ErrorLogger().log(userRef: "\(USER)", sender: self, funcRef: #function, errorRef: "\(error)")

     */
    func log(userRef: String, sender: Any, funcRef: String, errorRef: String) {
        
        print("🚨 ErrorLogger: \(errorRef)")

        let classRef = type(of: sender)
        let info: NSDictionary = (Bundle.main.infoDictionary)! as NSDictionary
        let model = UIDevice.current.modelName
        let OS = UIDevice.current.systemVersion

        let logMessage = "User:\n         - \(userRef)\n\n" +
                         "Device:\n         -Model: \(model), iOS: \(OS)\n\n" +
                         "App:\n         - \(appName) (\(info.object(forKey: "CFBundleShortVersionString")!) (\(info.object(forKey: "CFBundleVersion")!)))\n\n" +
                         "Class:\n         - \(classRef)\n\n" +
                         "Function:\n         - \(funcRef)\n\n" +
                         "Error:\n         - \(errorRef)"
        
        let request = NSMutableURLRequest()
        request.url = endpoint
        request.httpMethod = "POST"
        let postString = "app=\(appName)&log=\(logMessage)"
        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                print("🚨 ErrorLogger: failed = \(error!.localizedDescription)")
            } else {
                if let stringData = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print("🚨 ErrorLogger: \(stringData)")
                }
            }
        }) 
        
        task.resume()
    }
}
