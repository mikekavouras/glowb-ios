//
//  SingleButtonTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class SingleActionTableViewCell: BaseTableViewCell, ReusableView {

    static var identifier: String = "SingleActionCellIdentifier"
    static var nibName: String = "SingleActionTableViewCell"
    
    @IBOutlet weak var label: PrimaryTextLabel!
}
