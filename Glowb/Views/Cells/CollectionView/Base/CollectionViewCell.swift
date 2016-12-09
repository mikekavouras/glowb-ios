//
//  CollectionViewCell.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class CollectionViewCell: UICollectionViewCell, Styleable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
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
