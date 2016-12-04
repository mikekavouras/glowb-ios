//
//  SelectionRepresentableTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class TextSelectionRepresentableTableViewCell: BaseTableViewCell, ReusableView {
    
    static var identifier: String = "TextSelectionRepresentableCellIdentifier"
    static var nibName: String = "TextSelectionRepresentableTableViewCell"
    
    @IBOutlet weak var label: PrimaryTextLabel!
    @IBOutlet weak var selectionLabel: SecondaryTextLabel!
}
