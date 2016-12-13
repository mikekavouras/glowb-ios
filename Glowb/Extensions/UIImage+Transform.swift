//
//  UIImage+Transform.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/13/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

extension UIImage {
    func scale(amount: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * amount, height: size.height * amount)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
