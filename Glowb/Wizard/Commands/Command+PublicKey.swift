//
//  PublicKeyCommand.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 10/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

extension Command {
    struct PublicKey: ParticleCommunicable {
        static var command: String = "public-key\n0\n\n"
        
        internal static func parse(_ json: JSON) -> Int? {
            guard let key = json["b"] as? String,
                let r = json["r"] as? Int else
            { return nil }
            
            guard let pubKey = try! Security.decode(fromHexString: key) else { return nil }
            do {
                try Security.setPublicKey(data: pubKey)
            } catch { return nil }
            
            return r
        }
    }
}
