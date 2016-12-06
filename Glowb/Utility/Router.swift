//
//  Router.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation
import Alamofire


enum Router {
    
}

extension Router {
    
    static let apiRoot: String = "" // Teespring.Config.mobileServiceAPI!
    fileprivate static let appId: String = "" // Teespring.Config.mobileServiceAppID!
    
    fileprivate var method: Alamofire.HTTPMethod {
        return .post
    }
    
    fileprivate var path: String {
        return ""
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: "\(Router.apiRoot)")!
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
//        switch self {
//        case .info:
//            let parameters = [ "app_id" : MobileService.Router.appId ]
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        case .activateNotifications(let userId, let token):
//            var parameters: JSON = [ "apns_token" : token, "app_id" : MobileService.Router.appId ]
//            if let id = userId { parameters["user_id"] = id }
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        case .deactivateNotifications(let token):
//            let parameters = [ "apns_token" : token, "app_id" : MobileService.Router.appId ]
//            request = try JSONEncoding.default.encode(request, with: parameters)
//        }
        
        return request
    }
}
