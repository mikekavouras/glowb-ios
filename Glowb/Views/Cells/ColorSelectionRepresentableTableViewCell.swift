//
//  ColorSectionRepresentableTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class ColorSelectionRepresentableTableViewCell: BaseTableViewCell, ReusableView {
    
    static var identifier: String = "ColorSelectionRepresentableCellIdentifier"
    static var nibName: String = "ColorSelectionRepresentableTableViewCell"
    
    @IBOutlet weak var label: PrimaryTextLabel!
    @IBOutlet weak var colorPreviewView: ColorPreviewView!
}
