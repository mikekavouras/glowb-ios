//
//  Button.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton, Styleable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if Target.current != TargetType.interfaceBuilder {
            style()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        style()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        style()
    }
    
    internal func style() {}
}
