//
//  ColorSelectionTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class ColorSelectionTableViewCell: BaseTableViewCell, ReusableView, Selectable  {
    static var identifier: String = "ColorSelectionCellIdentifier"
    static var nibName: String = "ColorSelectionTableViewCell"
    
    var selectedState: SelectedState = .deselected {
        didSet { updateStateUI() }
    }
    
    var color: UIColor? {
        get { return colorPreviewView.color }
        set { colorPreviewView.color = newValue }
    }
    
    @IBOutlet private weak var selectedIndicator: UIImageView!
    @IBOutlet private weak var colorPreviewView: ColorPreviewView!
    
    private func updateStateUI() {
        selectedIndicator.isHidden = selectedState == .deselected
    }
}
