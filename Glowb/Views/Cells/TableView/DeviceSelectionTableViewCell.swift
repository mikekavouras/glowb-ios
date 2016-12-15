//
//  DeviceSelectionTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceSelectionTableViewCell: BaseTableViewCell, ReusableView, Selectable {
    static var identifier: String = "DeviceSelectionCellIdentifier"
    static var nibName: String = "DeviceSelectionTableViewCell"
    
    var selectedState: SelectedState = .deselected {
        didSet { updateStateUI() }
    }
    
    @IBOutlet private weak var selectedIndicator: UIImageView!
    @IBOutlet weak var label: PrimaryTextLabel!
    
    private func updateStateUI() {
        selectedIndicator.isHidden = selectedState == .deselected
    }
}
