//
//  Functions.swift
//  Sales Hub
//
//  Created by Jamie Currie on 05/01/2017.
//  Copyright © 2017 BigDogAgency. All rights reserved.
//

import UIKit

class Functions: NSObject {
    
    
    func isJailbroken() -> Bool {
        
        #if !((arch(i386) || arch(x86_64)) && os(iOS))
            
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") {
                print("🛡 Jailbrake detected")
                return true
            }
            
            if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
                print("🛡 Jailbrake detected")
                return true
            }
            
            if FileManager.default.fileExists(atPath: "/bin/bash") {
                print("🛡 Jailbrake detected")
                return true
            }
            
            if FileManager.default.fileExists(atPath: "/usr/sbin/sshd") {
                print("🛡 Jailbrake detected")
                return true
            }
            
            if FileManager.default.fileExists(atPath: "/etc/apt") {
                print("🛡 Jailbrake detected")
                return true
            }
            
            
            let stringToBeWritten = "This is a test."
            
            do {
                try stringToBeWritten.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: String.Encoding.utf8)
                print("🛡 Jailbrake detected")
                return true
            } catch {
                try? FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
            }
            
            if UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
                print("🛡 Jailbrake detected")
                return true
            }
            
        #endif
        print("🛡 Device not jailbroken")
        return false
    }
    
    
}
