//
//  Invite.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/7/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit

struct Invite {
    let token: String
    
    static func create(invite: Invite) -> Promise<Invite> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createInvite).validate().responseJSON { response in
                fulfill(Invite(token: ""))
            }
        }
    }
    
    static func claim(invite: Invite) -> Promise<Invite> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.claimInvite(invite)).validate().responseJSON { response in
                fulfill(Invite(token: ""))
            }
        }
    }
}
