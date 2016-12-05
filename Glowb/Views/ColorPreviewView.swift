//
//  ColorPreviewView.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class ColorPreviewView: View {
    
    @IBInspectable var color: UIColor = .white {
        didSet { style() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        style()
    }
    
    override func style() {
        super.style()
        
        layer.cornerRadius = frame.size.height / 2.0
        backgroundColor = color
    }
}
