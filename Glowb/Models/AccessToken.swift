//
//  AccessToken.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/9/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import PromiseKit
import Alamofire
import Locksmith

enum AccessTokenError: Error {
    case failedToParseAccessToken
}

struct AccessToken {
    
    static var current: String? {
        get {
            if let data = Locksmith.loadDataForUserAccount(userAccount: "com.mikekavouras.Glowb"),
               let token = data["access_token"] as? String
            { return token }
            
            return nil
        }
        set {
            if let token = newValue {
                try? Locksmith.saveData(data: ["access_token" : token], forUserAccount: "com.mikekavouras.Glowb")
            } else {
                try? Locksmith.deleteDataForUserAccount(userAccount: "com.mikekavouras.Glowb")
            }
        }
    }
    
    static func create() -> Promise<String> {
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
    
    func refresh() -> Promise<String> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.refreshOAuthToken).validate().responseJSON { response in
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
    
    func revoke() -> Promise<Void> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.revokeOAuthToken).validate().responseJSON { response in
                if response.result.isSuccess {
                    fulfill()
                } else {
                    reject(ServerError.invalidStatus)
                }
            }
        }
    }
}

private struct AccessTokenParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<String> {
        guard let token = json["access_token"] as? String else {
            return .failure(AccessTokenError.failedToParseAccessToken)
        }
        return .success(token)
    }
}
