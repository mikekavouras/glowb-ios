//
//  Color.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

struct Color: Equatable {
    let color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
    }
}

func ==(lhs: Color, rhs: Color) -> Bool {
    return lhs.color.isEqual(rhs.color)
}
