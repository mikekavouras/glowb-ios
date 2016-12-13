
//
//  DevicesTableViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceSelectionTableViewController<Item: Selectable, Cell: ReusableView>: SelectableTableViewController<Item, Cell> {
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupNavigationItem()
        setupNotifications()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeviceButtonTapped))
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewDeviceConnected(notification:)), name: .particleDeviceConnected, object: nil)
    }
    
    @objc private func handleNewDeviceConnected(notification: Notification) {
        if let id = notification.userInfo?["device_id"] as? String {
            Device.create(deviceId: id, name: "Slinky").then { device -> Void in
                User.current.devices.append(device)
                self.dismiss(animated: true, completion: nil)
                self.refreshDevices()
            }.catch { error in
                print(error)
            }
        }
    }
    
    private func refreshDevices() {
        let devices = User.current.devices
        let selectableDevices = devices.map { SelectableViewModel(model: $0, selectedState: .deselected) }
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit")
        
        // delete device
        // reload table
    }
    
    
    // MARK: - Actions
    
    @objc private func addDeviceButtonTapped() {
        let viewController = WizardIntroViewController.initFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = CardTransitioningDelegate.shared
        navigationController.modalPresentationStyle = .custom
        
        present(navigationController, animated: true, completion: nil)
    }
}
