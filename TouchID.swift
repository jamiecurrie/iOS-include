//
//  TouchID.swift
//  Sales Hub
//
//  Created by Jamie Currie on 21/10/2016.
//  Copyright © 2016 BigDogAgency. All rights reserved.
//

import LocalAuthentication

@available(iOS 9.0, *)
protocol TouchIDDelegate {
    func TouchIdDidAuthenticateUser()
    func TouchIdDidFailWithError(error: Error)
}

@available(iOS 9.0, *)
class TouchID: NSObject {
    
    let mContext  = LAContext()
    var mDelegate: TouchIDDelegate!
    
    init(delegate: TouchIDDelegate) {
        super.init()
        mDelegate = delegate
    }
    
    func authenticateUser(reason: String) {
      
        mContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
            
            if success {
                self.mDelegate.TouchIdDidAuthenticateUser()
            } else{
                self.mDelegate.TouchIdDidFailWithError(error: error!)
            }
        })
    }
}
