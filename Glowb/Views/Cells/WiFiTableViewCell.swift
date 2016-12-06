//
//  WiFiTableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class WiFiTableViewCell: BaseTableViewCell, ReusableView {
    
    static var identifier: String = "WiFiCellIdentifier"
    static var nibName: String = "WiFiTableViewCell"

    @IBOutlet weak var networkNameLabel: PrimaryTextLabel!
}
