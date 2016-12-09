//
//  User.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit

enum UserError: Error {
    case failedToParseAccessToken
}

struct User {
    static var current = User()
    
    var accessToken: String? {
        get {
            return AccessToken.current
        }
        set {
            AccessToken.current = newValue
        }
    }
    
    private var isRegistered: Bool {
        return accessToken != nil
    }
    
    @discardableResult
    func register() -> Promise<String> {
        
        if isRegistered {
            return Promise(value: User.current.accessToken!)
        }
        
        return AccessToken.create()
    }
}
