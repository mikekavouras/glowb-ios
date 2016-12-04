//
//  TableViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/4/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class TableViewCell: UITableViewCell, Styleable {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        style()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        style()
    }
    
    internal func style() {}
}
