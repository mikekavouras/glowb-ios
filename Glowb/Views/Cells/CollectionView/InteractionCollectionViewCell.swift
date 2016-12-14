//
//  InteractionCollectionViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/13/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class InteractionCollectionViewCell: BaseCollectionViewCell, ReusableView {
    static var identifier: String = "InteractionCellIdentifier"
    static var nibName: String = "InteractionCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
} 
