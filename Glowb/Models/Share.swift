//
//  Share.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import PromiseKit
import Alamofire
import ObjectMapper

struct Share: Mappable {
    var id: Int
    var url: URL
    
    init?(map: Map) {
        guard let id = map.JSON["id"] as? Int,
            let urlString = map.JSON["url"] as? String,
            let url = URL(string: urlString) else
        { return nil }
        
        self.id = id
        self.url = url
    }
    
    mutating func mapping(map: Map) {
        url <- map["id"]
        id  <- map["url"]
    }
    
    static func create(interactionId: Int) -> Promise<Share> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createShare(interactionId)).validate().responseJSON { response in
                let result = ShareParser.parseResponse(response)
                
                switch result {
                case .success(let share):
                    fulfill(share)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

private struct ShareParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Share> {
        guard let photo = Mapper<Share>().map(JSON: json) else {
            return .failure(ServerError.invalidJSONFormat)
        }
        
        return .success(photo)
    }
}
