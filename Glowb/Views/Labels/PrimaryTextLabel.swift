//
//  PrimaryTextLabel.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class PrimaryTextLabel: Label, Themeable {

    var theme: Theme = .light {
        didSet { style() }
    }
    
    @IBInspectable var themeAdapter: Int {
        get {
            return theme.rawValue
        }
        set {
            theme = Theme(rawValue: newValue) ?? .light
        }
    }
    
    override func style() {
        super.style()
        
        textColor = theme.primaryTextColor
    }

}
