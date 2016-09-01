//
//  connectionDeamon.swift
//  Rolls_Royce
//
//  Created by Jamie Currie on 26/07/2016.
//  Copyright © 2016 Big Dog Agency. All rights reserved.
//

import Foundation
import SystemConfiguration

public class ConnectionDeamon {
    
    var loop: NSTimer!
    var mInterval: Double = 1.0
    var connected = true
    let events = EventManager()
    
    func start () {
        print("😈 ConnectionDeamon Starting...")
        loop = NSTimer.scheduledTimerWithTimeInterval(mInterval, target: self, selector: #selector(ConnectionDeamon.deamon), userInfo: nil, repeats: true)
    }
    
    func stop () {
        print("😈 ConnectionDeamon Stopped!")
        loop.invalidate()
    }
    
    @objc private func deamon() {
        if !ConnectionDeamon.isConnectedToNetwork() {
            if (connected) {
                print("😈 CONNECTION_LOST")
                connected = false
                self.events.trigger("CONNECTION_LOST")
            }
        } else {
            if (!connected) {
                print("😈 CONNECTION_FOUND")
                connected = true
                self.events.trigger("CONNECTION_FOUND")
            }
        }
    }
    
    private class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
