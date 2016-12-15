//
//  Router.swift
//  Glowb
// //  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String: Any]

enum APIError: Error {
    case keyNotFound
}

enum Router: URLRequestConvertible {
    
    case createOAuthToken
    case refreshOAuthToken
    case revokeOAuthToken
    
    case getDevices
    case getDevice
    case createDevice(String, String)
    case deleteDevice(Int)
    case resetDevice(Int)
    
    case getInteractions
    case createInteraction(Interaction)
    case updateInteraction(Interaction)
    case createEvent(Interaction)
    
    case createInvite
    case claimInvite(Invite)
    
    case getPhotos
    case createPhoto
    case updatePhoto(Photo)
    
    fileprivate static let apiRoot: String = Plist.Config.APIRoot
    fileprivate static let appID: String = Plist.Config.appId
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
            return try URLEncoding.default.encode(request, with: [:])
        case .getDevice(let deviceId):
            let params = [ "device_id" : deviceId ]
            return try URLEncoding.default.encode(request, with: params)
        case .createDevice(let deviceId, let name):
            let params = [ "particle_id" : deviceId, "name" : name ]
            return try JSONEncoding.default.encode(request, with: params)
        case .deleteDevice:
            return try JSONEncoding.default.encode(request, with: [:])
        case .resetDevice:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .getInteractions:
            return try URLEncoding.default.encode(request, with: [:])
        case .createInteraction(let interaction):
            let params: JSON = [
                "user_device_id" : interaction.device?.id ?? -1,
                "name" : interaction.name,
                "photo_id" : interaction.photo?.id ?? ""
            ]
            return try JSONEncoding.default.encode(request, with: params)
        case .updateInteraction(let interaction):
            let params: JSON = [
                "user_device_id" : interaction.device?.id ?? -1,
                "name" : interaction.name,
                "photo_id" : interaction.photo?.id ?? ""
            ]
            return try JSONEncoding.default.encode(request, with: params)
        case .createEvent:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .createInvite:
            return try JSONEncoding.default.encode(request, with: [:])
        case .claimInvite(let invite):
            let params = [ "token" : invite.token ]
            return try JSONEncoding.default.encode(request, with: params)
            
        case .getPhotos:
            return try URLEncoding.default.encode(request, with: [:])
        case .createPhoto:
            return try JSONEncoding.default.encode(request, with: [:])
        case .updatePhoto(let photo):
            let params = photo.toJSON()
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
        case .updateInteraction:
            return .patch
        case .createEvent:
            return .post
            
        case .createInvite:
            return .post
        case .claimInvite:
            return .post
        
        case .getPhotos:
            return .get
        case .createPhoto:
            return .post
        case .updatePhoto:
            return .patch
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
            return "/api/v1/interactions"
        case .getInteractions:
            return "/api/v1/interactions"
        case .updateInteraction(let interaction):
            return "/api/v1/interactions/\(interaction.id!)"
        case .createEvent(let interaction):
            return "/api/v1/interactions/\(interaction.id!)"
            
        case .createInvite:
            return "/invite"
        case .claimInvite:
            return "/invite/accept"
            
        case .getPhotos:
            return "/api/v1/photos"
        case .createPhoto:
            return "/api/v1/photos"
        case .updatePhoto(let photo):
            return "/api/v1/photos/\(photo.id!)"
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
