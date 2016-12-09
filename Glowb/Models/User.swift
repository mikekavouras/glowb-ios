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

enum UserError: Error {
    case failedToParseAccessToken
}

enum APIError: Error {
    case keyNotFound
}

struct User {
    static var current = User()
    var accessToken: String? {
        get {
            if let data = Locksmith.loadDataForUserAccount(userAccount: "com.mikekavouras.Glowb"),
               let token = data["access_token"] as? String
            { return token }
            
            return nil
        }
        set {
            if let token = newValue {
                try? Locksmith.saveData(data: ["access_token" : token], forUserAccount: "com.mikekavouras.Glowb")
            }
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
        
        return Promise { fulfill, reject in
            Alamofire.request(Router.createOAuthToken).validate().responseJSON { response in
                let result = AccessTokenParser.parseResponse(response)
                
                switch result {
                case .success(let token):
                    fulfill(token)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

struct AccessTokenParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<String> {
        if let token = json["access_token"] as? String {
            return .success(token)
        } else {
            return .failure(UserError.failedToParseAccessToken)
        }
    }
}
