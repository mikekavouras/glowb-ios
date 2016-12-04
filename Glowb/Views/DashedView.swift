//
//  DashedView.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DashedView: BaseView {
    
    private var _loaded = false
    private let shapeLayer = CAShapeLayer()

    override func draw(_ rect: CGRect) {
        let path = CGMutablePath()
        path.addRect(bounds)
        shapeLayer.path = path
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.frame = bounds
        shapeLayer.position = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineDashPattern = [9, 9]
        
        if !_loaded {
            _loaded = true
            layer.addSublayer(shapeLayer)
        }
    }
}
