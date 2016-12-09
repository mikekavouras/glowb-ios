//
//  UICollectionView+ReusableView.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func register<T: ReusableView>(cellType: T.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    public func register<T: ReusableView>(headerFooterViewType: T.Type, kind: String) {
        register(headerFooterViewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerFooterViewType.identifier)
    }
    
    public func dequeueReusable<T: ReusableView>(cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)")
        }
        
        return cell
    }
    
    public func dequeueReusable<T: ReusableView>(headerFooterViewType: T.Type, ofKind kind: String, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerFooterViewType.identifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(headerFooterViewType)")
        }
        
        return cell
    }
}
