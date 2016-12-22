//
//  Invite.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/7/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit
import ObjectMapper

enum InviteError: Error {
    case failedToParse
}

struct Invite: Mappable {
    var token: String!
    var usageLimit: Int = 0
    var expiresAt: Date?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        token      <- map["token"]
        usageLimit <- map["usage_limit"]
        expiresAt  <- (map["expires_at"], RubyDateTransform())
    }
    
    static func create(deviceId: Int, expiresAt: Date = 1.day.fromNow, limit: Int = 1) -> Promise<Invite> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createInvite(deviceId, expiresAt, limit)).validate().responseJSON { response in
                let result = InviteParser.parseResponse(response)
                
                switch result {
                case .success(let invite):
                    fulfill(invite)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func claim(name: String, code: String) -> Promise<Device> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.claimInvite(name, code)).validate().responseJSON { response in
                let result = DeviceParser.parseResponse(response)
                
                switch result {
                case .success(let device):
                    fulfill(device)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

private struct InviteParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Invite> {
        guard let invite = Mapper<Invite>().map(JSON: json) else {
            return .failure(InviteError.failedToParse)
        }
        
        return .success(invite)
    }
}
