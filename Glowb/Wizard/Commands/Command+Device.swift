//
//  DeviceCommand.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 10/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

extension Command {
    struct Device: ParticleCommunicable {
        static var command: String = "device-id\n0\n\n"
        
        internal static func parse(_ json: JSON) -> (deviceId: String, claimed: Bool)? {
            guard let id = json["id"] as? String,
                let c = json["c"] as? String,
                let cInt = Int(c) else
            { return nil }
            
            return (deviceId: id, claimed: cInt == 1)
        }
    }
}
