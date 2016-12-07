//
//  User.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit
import Locksmith

struct User {
    static let current = User()
    var accessToken: String? {
        get {
            if let data = Locksmith.loadDataForUserAccount(userAccount: "GlowbAccount"),
               let token = data["access_token"] as? String
            { return token }
            
            return nil
        }
        set {
            if let token = newValue {
                try? Locksmith.saveData(data: ["access_token" : token], forUserAccount: "GlowbAccount")
            }
        }
    }
    
    private var isRegistered: Bool {
        return accessToken != nil
    }
    
    func register() -> Promise<User> {
        if isRegistered {
            return Promise(value: User.current)
        }
        
        return Promise { fulfill, reject in
            Alamofire.request(Router.createOAuthToken).validate().responseJSON { response in
                // TODO: Parse and store 🔑
                
                fulfill(User.current) 
            }
        }
    }
}
