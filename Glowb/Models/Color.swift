//
//  Color.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat)

struct Color: Equatable {
    let color: UIColor
    
    init(_ color: UIColor) {
        self.color = color
    }
    
    init(_ rgb: RGB) {
        let red: CGFloat = rgb.red / 255.0
        let green: CGFloat = rgb.green / 255.0
        let blue: CGFloat = rgb.blue / 255.0
        
        color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    var rgbRepresentation: RGB {
        return (red: color.ciColor.red, green: color.ciColor.green, blue: color.ciColor.blue)
    }
}

func ==(lhs: Color, rhs: Color) -> Bool {
    return lhs.color.isEqual(rhs.color)
}
