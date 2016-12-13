//
//  Interaction.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit

struct Interaction {
    var color: Color?
    var device: Device?
    var photo: Photo?
    var name: String = ""
    
    init(color: Color, device: Device) {
        self.color = color
        self.device = device
    }
    
    init() {}
    
    
    // MARK: - API
    
    static func create(_ interaction: Interaction) -> Promise<Interaction> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.createInteraction(interaction)).validate().responseJSON { response in
                fulfill(Interaction())
            }
        }
    }
    
    static func fetch() -> Promise<[Interaction]> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.getInteractions).validate().responseJSON { response in
                fulfill([Interaction()])
            }
        }
    }
    
}

//private struct InteractionParser: ServerResponseParser {
//    static func parseJSON(_ json: JSON) -> Alamofire.Result<[Interaction]> {
//        if let data = json["data"] as? [JSON] {
//            let devices: [Device] = data.flatMap { Mapper<Interaction>().map(JSON: $0) }
//            return .success(devices)
//        } else {
//            return .failure(DeviceError.failedToParse)
//        }
//    }
//}
