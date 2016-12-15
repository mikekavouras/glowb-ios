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
    var color: Color? {
        didSet { updateRGB() }
    }
    var device: Device?
    var photo: Photo?
    var name: String = ""
    var id: Int?
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    
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
        red    <- map["red"]
        green  <- map["green"]
        blue   <- map["blue"]
    }
    
    
    private mutating func updateRGB() {
        guard let color = color?.color else { return }
        
        red = 0
        green = 0
        blue = 0
        
        if color == UIColor.red {
            red = 255
        } else if color == UIColor.green {
            green = 255
        } else if color == UIColor.blue {
            blue = 255
        }
    }
    
    var asJSON: JSON {
        return [
            "user_device_id" : device?.id ?? -1,
            "name" : name,
            "photo_id" : photo?.id ?? "",
            "red" : red,
            "green" : green,
            "blue" : blue
        ]
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
    
    static func update(_ interaction: Interaction) -> Promise<Interaction> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.updateInteraction(interaction)).validate().responseJSON { response in
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
        }
    }
    
}


func ==(lhs: Interaction, rhs: Interaction) -> Bool {
    guard lhs.id != nil, rhs.id != nil else { return false }
    return lhs.id! == rhs.id!
}


// MARK: - Parser

private struct InteractionParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Interaction> {
        guard let interaction = Mapper<Interaction>().map(JSON: json) else {
            return .failure(InteractionError.failedToParse)
        }
        
        return .success(interaction)
    }
}

private struct InteractionsParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<[Interaction]> {
        guard let data = json["interactions"] as? [JSON] else {
            return .failure(ServerError.invalidJSONFormat)
        }
        
        let interactions: [Interaction] = data.flatMap { Mapper<Interaction>().map(JSON: $0) }
        return .success(interactions)
    }
}
