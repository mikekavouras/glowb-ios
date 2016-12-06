//
//  Network.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 8/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation

struct Network {
    let sec: UInt
    let mdr: UInt
    let ssid: String
    let rssi: Int
    let ch: Int
    
    var password: String = ""
    
    init(json: JSON) {
        sec =  (json["sec"] as? UInt) ?? 0
        mdr =  (json["mdr"] as? UInt) ?? 0
        ssid = (json["ssid"] as? String) ?? "unknown"
        rssi = (json["rssi"] as? Int) ?? 0
        ch =   (json["ch"] as? Int) ?? 0
    }
    
    var asJSON: JSON? {
        guard let publicKey = try! Security.getPublicKey(),
            let passwordData = password.data(using: .utf8),
            let cipherData = Security.encryptWith(publicKey: publicKey, plainText: passwordData),
            let hexPassword = try! Security.encode(toHexString: cipherData) else
        {
            return nil
        }
        
        let request: JSON = [
            "idx" : 0,
            "ssid": ssid,
            "pwd": hexPassword,
            "sec": sec,
            "ch": ch
        ]
        
        return request
    }
}
