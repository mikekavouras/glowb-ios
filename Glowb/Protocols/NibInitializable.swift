//
//  NibInitializable.swift
//  Buyer
//
//  Created by Mike Kavouras on 8/23/16.
//  Copyright © 2016 Teespring. All rights reserved.
//

import UIKit

public protocol NibInitializable: class {
    static var nibName: String { get }
}

extension NibInitializable where Self: UIView {
    public static func initFromNib() -> Self {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        return nib!.first as! Self
    }
}
