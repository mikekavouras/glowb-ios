//
//  Router.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire


enum Router: URLRequestConvertible {
    case createOAuthToken(deviceID: String)
    case refreshOAuthToken
}

extension Router {
    
    static let apiRoot: String = "" // Config.APIRoot
    fileprivate static let appId: String = "" // Config.AppID
    
    fileprivate var method: Alamofire.HTTPMethod {
        switch self {
        case .createOAuthToken:
            return .post
        case .refreshOAuthToken:
            return .post
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .createOAuthToken:
            return "/oauth"
        case .refreshOAuthToken:
            return "/oauth/refresh"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Router.apiRoot)")!
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        switch self {
        case .createOAuthToken(let deviceID):
            let parameters = [ "app_id" : Router.appId, "device_id" : deviceID ]
            request = try JSONEncoding.default.encode(request, with: parameters)
        case .refreshOAuthToken:
            let parameters = [ "app_id" : Router.appId, "access_token" : "" ]
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
        
        return request
    }
}
