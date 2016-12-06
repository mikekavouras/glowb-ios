//
//  ParticleCommunicable.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 10/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

protocol ParticleCommunicable {
    static var command: String { get }
    associatedtype ResponseType
    static func parse(_ json: JSON) -> ResponseType?
}
