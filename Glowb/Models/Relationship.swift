//
//  Relationship.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit

struct Relationship {
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
    
    static func create(relationship: Relationship) -> Promise<Relationship> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.createRelationship(relationship)).validate().responseJSON { response in
                fulfill(Relationship())
            }
        }
    }
    
    static func fetch() -> Promise<[Relationship]> {
        return Promise { fulfill, reject in
            return Alamofire.request(Router.getRelationships).validate().responseJSON { response in
                fulfill([Relationship()])
            }
        }
    }
    
}
