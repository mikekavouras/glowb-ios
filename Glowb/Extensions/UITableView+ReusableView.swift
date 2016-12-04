//
//  UITableView+ReusableView.swift
//  Buyer
//
//  Created by Mike Kavouras on 8/23/16.
//  Copyright © 2016 Teespring. All rights reserved.
//

import UIKit

extension UITableView {
    public func register<T: ReusableView>(cellType: T.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }
    
    public func register<T: ReusableView>(headerFooterViewType: T.Type) {
        register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.identifier)
    }
    
    public func dequeueReusable<T: ReusableView>(cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)")
        }
        
        return cell
    }
    
    public func dequeueReusable<T: ReusableView>(headerFooterViewType: T.Type) -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: headerFooterViewType.identifier) as? T else {
            fatalError("Misconfigured cell type, \(headerFooterViewType)")
        }
        
        return cell
    }
}
