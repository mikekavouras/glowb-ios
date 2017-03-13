//
//  PrimaryButton.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class PrimaryButton: Button, Themeable {

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
        
        setTitleColor(theme.primaryTextColor, for: .normal)
        backgroundColor = theme.tintColor.withAlphaComponent(0.05)
    }
}
