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
    
    // auth
    case createOAuthToken
    case refreshOAuthToken
    case revokeOAuthToken
    
    // devices
    case getDevices
    case getDevice
    case updateDevice(Int, String)
    case createDevice(String, String)
    case deleteDevice(Int)
    case resetDevice(Int)
    
    // interactions
    case getInteractions
    case createInteraction(Interaction)
    case updateInteraction(Interaction)
    case deleteInteraction(Int)
    case createEvent(Interaction)
    
    // invites
    case createInvite(Int, Date, Int)
    case claimInvite(String, String)
    
    // photos
    case getPhotos
    case createPhoto
    case updatePhoto(Photo)
    
    // shares
    case createShare(Int)
    case deleteShare(Share)
    
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
        case .updateDevice(_, let name):
            let params = [ "name" : name ]
            return try JSONEncoding.default.encode(request, with: params)
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
            let params = interaction.asJSON
            return try JSONEncoding.default.encode(request, with: params)
        case .updateInteraction(let interaction):
            let params = interaction.asJSON
            return try JSONEncoding.default.encode(request, with: params)
        case .deleteInteraction:
            return try URLEncoding.default.encode(request, with: [:])
        case .createEvent:
            return try JSONEncoding.default.encode(request, with: [:])
            
        case .createInvite(let deviceId, let expiresAt, let limit):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let dateString = formatter.string(from: expiresAt)
            let params: JSON = [ "device_id" : deviceId, "expires_at" : dateString, "usage_limit" : limit ]
            return try JSONEncoding.default.encode(request, with: params)
        case .claimInvite(let name, let token):
            let params = [ "name" : name, "token" : token ]
            return try JSONEncoding.default.encode(request, with: params)
            
        case .getPhotos:
            return try URLEncoding.default.encode(request, with: [:])
        case .createPhoto:
            return try JSONEncoding.default.encode(request, with: [:])
        case .updatePhoto(let photo):
            let params = photo.toJSON()
            return try JSONEncoding.default.encode(request, with: params)
            
            
        case .createShare(let interactionId):
            let params = [ "interaction_id" : interactionId ]
            return try JSONEncoding.default.encode(request, with: params)
        case .deleteShare:
            return try URLEncoding.default.encode(request, with: [:])
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
        case .updateDevice:
            return .patch
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
        case .deleteInteraction:
            return .delete
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
        
        case .createShare:
            return .post
        case .deleteShare:
            return .delete
            
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
        case .updateDevice(let deviceID, _):
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
        case .deleteInteraction(let interactionId):
            return "/api/v1/interactions/\(interactionId)"
        case .createEvent(let interaction):
            return "/api/v1/interactions/\(interaction.id!)"
            
        case .createInvite:
            return "/api/v1/invites"
        case .claimInvite:
            return "/api/v1/invites/accept"
            
        case .getPhotos:
            return "/api/v1/photos"
        case .createPhoto:
            return "/api/v1/photos"
        case .updatePhoto(let photo):
            return "/api/v1/photos/\(photo.id!)"
            
        case .createShare:
            return "/api/v1/shares"
        case .deleteShare(let share):
            return "/api/v1/shares/\(share.id)"
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
