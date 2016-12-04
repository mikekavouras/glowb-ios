//
//  Themeable.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

protocol Themeable {
    var theme: Theme { get set }
    var themeAdapter: Int { get set }
}

enum Theme: Int {
    case light
    case dark
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .glowbBlack
        }
    }
    
    var primaryTextColor: UIColor {
        switch self {
        case .light:
            return .glowbBlack
        case .dark:
            return .white
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .light:
            return .lightGray
        case .dark:
            return .glowbDarkGray
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
}
