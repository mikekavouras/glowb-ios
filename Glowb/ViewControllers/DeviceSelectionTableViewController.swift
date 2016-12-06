
//
//  DevicesTableViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceSelectionTableViewController<Item: Selectable, Cell: ReusableView>: SelectableTableViewController<Item, Cell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeviceButtonTapped))
    }
    
    @objc private func addDeviceButtonTapped() {
       print("add device")
    }
}
