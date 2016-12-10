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
    
    init(color: Color, device: Device) {
        self.color = color
        self.device = device
    }
    
    init() {}
    
    var asJSON: JSON {
        return [:]
    }
    
    static func create(interaction: Interaction) -> Promise<Interaction> {
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
