//
//  BaseTextField.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class BaseTextField: TextField, Themeable {
    
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
        
        // style primary text color
        textColor = theme.primaryTextColor
        
        // style placeholder text color
        let str = NSAttributedString(string: placeholder ?? "", attributes: [
            NSAttributedStringKey.foregroundColor: theme.secondaryTextColor
        ])
        attributedPlaceholder = str
        
        tintColor = theme.tintColor
//        backgroundColor = theme.secondaryBackgroundColor
        
        if borderStyle == .none {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        }
    }
}
