//
//  TextViewTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: BaseTableViewCell, ReusableView {
    static var identifier: String = "TextFieldCellIdentifier"
    static var nibName: String = "TextFieldTableViewCell"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
}
