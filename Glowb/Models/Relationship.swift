//
//  Relationship.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

struct Relationship {
    var color: Color?
    var device: Device?
    
    init(color: Color, device: Device) {
        self.color = color
        self.device = device
    }
    
    init() {}
    
    func build() -> Relationship? {
        guard let color = color,
            let device = device else
        {
            print("invalid relationship")
            return nil
        }
        
        return Relationship(color: color, device: device)
    }
}
