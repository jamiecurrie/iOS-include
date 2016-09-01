//
//  EndPoint.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 09/11/2015.
//  Copyright © 2015 Big Dog Agency. All rights reserved.
//

import UIKit

protocol endPointDelegate {
    func dataFromEndpoint(data: NSData, fromUrl: String)
    func displayError(error: NSError)
}

class EndPoint: NSObject {
    
    var endDelegate: endPointDelegate?
    var session = NSURLSession.sharedSession()
    
    // MARK: init
    init (deleage: endPointDelegate) {
        super.init()
        endDelegate = deleage
    }
    
    // MARK: delegates
    func addTask(request: NSMutableURLRequest) {
        
        if (ACCESSTOKEN != nil) {
            if let mtoken = ACCESSTOKEN {
                request.setValue(mtoken, forHTTPHeaderField: "btoken")
            } else {
                request.setValue("", forHTTPHeaderField: "btoken")
            }
            if (VERBOSELOG) {
                print("btoken: " + request.allHTTPHeaderFields!["btoken"]!)
            }
        }
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            if error != nil {
                print(error!)
                self.endDelegate?.displayError(error!)
            } else {
                if let r = response as? NSHTTPURLResponse {
                    print("⬇️ RESPONSE :", request.URL!.absoluteString, ", Status code: ", r.statusCode)
                    
                    if (r.statusCode == 200) {
                        self.endDelegate?.dataFromEndpoint(data!, fromUrl: (response!.URL?.absoluteString)!)
                        
                    } else if (r.statusCode == 403) {
                        print("❗️ <ERROR> Invalid token")
                        self.endDelegate?.dataFromEndpoint(data!, fromUrl: "invalid-token")
                    } else {
                        print("❗️ <ERROR> Can't reach endpoint")
                        ErrorLogger().log(self.dynamicType, funcRef: #function, errorRef: "\(r.statusCode)")
                        
                        self.endDelegate?.displayError(NSError(domain: "Can't reach endpoint", code: 42, userInfo: nil)) // error 42 because hitch hikers guide
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: POST
    func postToEndPoint (url: POSTURLS, postString: String) {
        let url = "\(BASEURL)\(url.rawValue)"
        print("⬆️ POST: ", url)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        addTask(request)
    }
    
    // MARK: GET
    func getFromEndPoint (url: GETURLS) {
        let url = "\(BASEURL)\(url.rawValue)"
        print("⬆️ GET: ", url)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60)
        request.HTTPMethod = "GET"
        
        addTask(request)
    }
    
    func getFromEndPoint (url: GETURLS, data: String) {
        let url = "\(BASEURL)\(url.rawValue)\(data)"
        print("⬆️ GET: ", url)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60)
        request.HTTPMethod = "GET"
        
        addTask(request)
    }
    
    func checkVersionWithUrl (url: GETURLS) {
        let url = "\(BASEURL)\(url.rawValue)"
        print("⬆️ GET: ", url)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 60)
        request.HTTPMethod = "GET"
        
        addTask(request)
    }
    
}
