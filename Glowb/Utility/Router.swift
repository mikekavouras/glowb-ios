//
//  Router.swift
//  Glowb
// //  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [AnyHashable: Any]

enum APIError: Error {
    case keyNotFound
}

enum Router: URLRequestConvertible {
    
    case createOAuthToken
    case refreshOAuthToken
    case revokeOAuthToken
    
    case getDevices
    case getDevice
    case createDevice
    case deleteDevice(String)
    case resetDevice(String)
    
    case createInteraction(Interaction)
    case getInteractions
    
    case createInvite
    case claimInvite(Invite)
    
    fileprivate static let apiRoot: String = Plist.Config.APIRoot
    fileprivate static let appID: String = Plist.Config.appID
}

extension Router {
    
    func asURLRequest() throws -> URLRequest {
        
        switch self {
        case .createOAuthToken:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .refreshOAuthToken:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .revokeOAuthToken:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .getDevices:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .getDevice(let deviceID):
            let params = [ "device_id" : deviceID ]
            return try JSONEncoding.default.encode(request, with: params)
            
        case .createDevice:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .deleteDevice:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .resetDevice:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .createInteraction(let interaction):
            let params = [ "interaction" : interaction.asJSON ]
            return try JSONEncoding.default.encode(request, with: params)
            
        case .getInteractions:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .createInvite:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .claimInvite(let invite):
            let params = [ "token" : invite.token ]
            return try JSONEncoding.default.encode(request, with: params)
        }
    }
    
    private var method: Alamofire.HTTPMethod {
        switch self {
        case .createOAuthToken:
            return .post
        case .refreshOAuthToken:
            return .post
        case .revokeOAuthToken:
            return .post
            
        case .getDevices:
            return .get
        case .getDevice:
            return .get
        case .createDevice:
            return .post
        case .deleteDevice:
            return .delete
        case .resetDevice:
            return .post
            
        case .createInteraction:
            return .post
        case .getInteractions:
            return .get
            
        case .createInvite:
            return .post
        case .claimInvite:
            return .post
        }
    }
    
    private var path: String {
        switch self {
            
        case .createOAuthToken:
            return "/api/v1/oauth"
        case .refreshOAuthToken:
            return "/api/v1/oauth/token"
        case .revokeOAuthToken:
            return "/api/v1/oauth/revoke"
            
        case .getDevices:
            return "/api/v1/devices"
        case .getDevice(let deviceID):
            return "/api/v1/devices/\(deviceID)"
        case .createDevice:
            return "/api/v1/devices"
        case .deleteDevice(let deviceID):
            return "/api/v1/devices/\(deviceID)"
        case .resetDevice(let deviceID):
            return "/api/v1/devices/reset/\(deviceID)"
            
        case .createInteraction:
            return "/interaction"
        case .getInteractions:
            return "/interactions"
            
        case .createInvite:
            return "/invite"
        case .claimInvite:
            return "/invite/accept"
        }
    }
    
    
    private var request: URLRequest {
        let url = URL(string: "\(Router.apiRoot)")!
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        request.setValue(Router.appID, forHTTPHeaderField: "X-Application-Id")
        if let token =  User.current.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
