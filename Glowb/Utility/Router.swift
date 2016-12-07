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
    case claimDevice(deviceCode: String)
    case getDevice(deviceID: String)
    case getDevices
}

extension Router {
    
    static let apiRoot: String = "https://lamp.engineering" // Config.APIRoot
    fileprivate static let appID: String = "abc123" // Config.AppID
    
    fileprivate var method: Alamofire.HTTPMethod {
        switch self {
        case .createOAuthToken:
            return .post
        case .refreshOAuthToken:
            return .post
        case .claimDevice:
            return .post
        case .getDevice:
            return .get
        case .getDevices:
            return .get
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .createOAuthToken:
            return "/oauth"
        case .refreshOAuthToken:
            return "/oauth/token"
        case .claimDevice:
            return "/device/claim"
        case .getDevice:
            return "/device"
        case .getDevices:
            return "devices"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Router.apiRoot)")!
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        request.setValue(Router.appID, forHTTPHeaderField: "X-Application-Id")
        if let token =  User.current.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .createOAuthToken:
            request = try JSONEncoding.default.encode(request, with: [:])
        case .refreshOAuthToken:
            request = try JSONEncoding.default.encode(request, with: [:])
        case .claimDevice(let code):
            let params = [ "code" : code ]
            request = try JSONEncoding.default.encode(request, with: params)
        case .getDevice(let deviceID):
            let params = [ "device_id" : deviceID ]
            request = try JSONEncoding.default.encode(request, with: params)
        case .getDevices:
            request = try JSONEncoding.default.encode(request, with: [:])
        }
        
        return request
    }
}
