//
//  ServerResponseParser.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/9/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

enum ServerError: Error {
    case unableToParseResponse
    case invalidStatus
}

protocol ServerResponseParser {
    associatedtype SuccessType
    static func parseResponse(_ response: DataResponse<Any>) -> Result<SuccessType>
    static func parseJSON(_ json: JSON) -> Result<SuccessType>
}

extension ServerResponseParser {
    static func parseResponse(_ response: DataResponse<Any>) -> Result<SuccessType> {
        
        if !response.result.isSuccess {
            return .failure(ServerError.invalidStatus)
        }
        
        guard let result = response.result.value as? JSON else {
            return .failure(ServerError.unableToParseResponse)
        }
        
        return Self.parseJSON(result)
    }
}

class JSONResponseParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<JSON> {
        return .success(json)
    }
}
