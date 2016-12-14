//
//  Interaction.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit
import ObjectMapper

enum InteractionError: Error {
    case failedToParse
}

struct Interaction: Mappable {
    var color: Color?
    var device: Device?
    var photo: Photo?
    var name: String = ""
    var id: String = ""
    
    var imageUrl: URL? {
        guard let token = photo?.token else { return nil }
        let string = "https://electrolamp-photos.s3.amazonaws.com/development/uploads/\(token).jpg"
        guard let url = URL(string: string) else { return nil }
        return url
    }
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id     <- map["id"]
        photo  <- map["photo"]
        device <- map["user_device"]
        name   <- map["name"]
    }
    
    
    // MARK: - API
    
    static func create(_ interaction: Interaction) -> Promise<Interaction> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.createInteraction(interaction)).validate().responseJSON { response in
                let result = InteractionParser.parseResponse(response)
                
                switch result {
                case .success(let interaction):
                    fulfill(interaction)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func fetchAll() -> Promise<[Interaction]> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.getInteractions).validate().responseJSON { response in
                let result = InteractionsParser.parseResponse(response)
                
                switch result {
                case .success(let interactions):
                    fulfill(interactions)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func interact() {
        Alamofire.request(Router.createEvent(self)).validate().responseJSON { response in
            print(response)
            print(response.result.value)
        }
    }
    
}


// MARK: - Parser

private struct InteractionParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Interaction> {
        guard let data = json["data"] as? JSON,
            let id = data["id"] as? String,
            let attributes = data["attributes"] as? JSON else
        { return .failure(ServerError.invalidJSONFormat) }
        
        var newJSON: JSON = attributes
        newJSON["id"] = id
        
        guard let interaction = Mapper<Interaction>().map(JSON: newJSON) else {
            return .failure(InteractionError.failedToParse)
        }
        
        return .success(interaction)
    }
}

private struct InteractionsParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<[Interaction]> {
        if let data = json["data"] as? [JSON] {
            let interactions: [Interaction] = data.flatMap { item in
                guard let id = item["id"] as? String,
                    let attributes = item["attributes"] as? JSON else
                { return nil }
                
                var newJSON: JSON = attributes
                newJSON["id"] = id
                
                return Mapper<Interaction>().map(JSON: newJSON)
            }
            return .success(interactions)
        } else {
            return .failure(InteractionError.failedToParse)
        }
    }
}
