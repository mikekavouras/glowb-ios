
//
//  DevicesTableViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceSelectionTableViewController<Item: Selectable, Cell: ReusableView>: SelectableTableViewController<Item, Cell> {
    
    private var hideStatusBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideStatusBar = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setup() {
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeviceButtonTapped))
    }
    
    @objc private func addDeviceButtonTapped() {
        let viewController = WizardIntroViewController.initFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = CardTransitioningDelegate.shared
        navigationController.modalPresentationStyle = .custom
        
        present(navigationController, animated: true, completion: nil)
        
        hideStatusBar = true
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
}
