//
//  SingleActionTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

enum ActionType {
    case `default`
    case destructive
    
}

class SingleActionTableViewCell: BaseTableViewCell, ReusableView {
    
    var actionType = ActionType.default {
        didSet { updateUI() }
    }
    
    static var identifier: String = "SingleActionCellIdentifer"
    static var nibName: String = "SingleActionTableViewCell"
    
    @IBOutlet weak var label: PrimaryTextLabel!
    
    private func updateUI() {
        if actionType == .destructive {
            label.textColor = .glowbRed
        }
    }
}
