//
//  ReusableView.swift
//  Buyer
//
//  Created by Mike Kavouras on 8/23/16.
//  Copyright © 2016 Teespring. All rights reserved.
//

import UIKit

public protocol ReusableView: NibInitializable {
    static var defaultCellHeight: CGFloat { get }
    static var nib: UINib { get }
    static var nibName: String { get }
    static var identifier: String { get }
}

extension ReusableView {
    public static var defaultCellHeight: CGFloat {
        return 52.0
    }
    
    public static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}
