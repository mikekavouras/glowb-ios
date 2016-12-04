//
//  TextViewTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class TextViewTableViewCell: BaseTableViewCell, ReusableView {
    static var identifier: String = "TextViewCellIdentifier"
    static var nibName: String = "TextViewTableViewCell"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
//    private var _textLabel: UILabel!
//    @IBOutlet override public var textLabel: UILabel! {
//        get { return _textLabel }
//        set {
//            _textLabel = newValue
//            _textLabel.text = nil
//        }
//    }

}
