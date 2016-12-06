//
//  ScanAP.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 10/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

extension Command {
    struct ScanAP: ParticleCommunicable {
        static var command: String = "scan-ap\n0\n\n"
        
        internal static func parse(_ json: JSON) -> [Network]? {
            guard let scans = json["scans"] as? [JSON] else {
                return nil
            }
            let networks = scans.map { Network(json: $0) }
            return networks.sorted(by: { $0.ssid < $1.ssid })
        }
    }
}
