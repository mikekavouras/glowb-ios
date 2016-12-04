//
//  BaseView.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class BaseView: View, Themeable {

    @IBInspectable var themeAdapter: Int {
        get {
            return theme.rawValue
        }
        set {
            theme = Theme(rawValue: newValue) ?? .light
        }
        
    }

    internal var theme: Theme = .light {
        didSet { style() }
    }
    
    override func style() {
        super.style()
        
        backgroundColor = theme.backgroundColor
    }

}
