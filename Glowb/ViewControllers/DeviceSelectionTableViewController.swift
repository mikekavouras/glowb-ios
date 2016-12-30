
//
//  DevicesTableViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceSelectionTableViewController: BaseTableViewController {
    
    var items: [SelectableViewModel<Device>] = []
    var selectionStyle: SelectionStyle = .single
    weak var delegate: SelectableTableViewControllerDelegate?
    
    
    // MARK: - Life cycle
    
    init(items: [SelectableViewModel<Device>]) {
        self.items = items
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupNavigationItem()
        setupNotifications()
        setupTableView()
    }
    
    private func setupNavigationItem() {
        title = "Device"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDeviceButtonTapped))
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewDeviceConnected(notification:)), name: .particleDeviceConnected, object: nil)
    }
    
    private func setupTableView() {
        tableView.register(cellType: DeviceSelectionTableViewCell.self)
    }
    
    
    // MARK: - Notification
    
    @objc private func handleNewDeviceConnected(notification: Notification) {
        if let id = notification.userInfo?["device_id"] as? String,
            let name = notification.userInfo?["device_name"] as? String {
            Device.create(deviceId: id, name: name).then { device -> Void in
                self.refreshDevices(device)
                self.dismiss(animated: true, completion: nil)
            }.catch { error in
                print(error)
            }
        }
    }
    
    fileprivate func refreshDevices(_ device: Device) {
        var devices = User.current.devices.filter { $0.id != device.id }
        devices.append(device)
        User.current.devices = devices
        
        let selectableDevices = User.current.devices.map { (item) -> SelectableViewModel<Device> in
            let state: SelectedState = (device == item) ? .selected : .deselected
            return SelectableViewModel(model: item, selectedState: state)
        }
        
        items = selectableDevices
        
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.selectableTableViewController(viewController: self, didSelectSelection: SelectableViewModel(model: device, selectedState: .selected))
        }
    }
        
    
    // MARK: - Actions
    
    @objc private func addDeviceButtonTapped() {
        let viewController = WizardIntroViewController.initFromStoryboard()
        viewController.delegate = self
        let navigationController = BaseNavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = CardTransitioningDelegate.shared
        navigationController.modalPresentationStyle = .custom
        
        present(navigationController, animated: true, completion: nil)
    }
}


// MARK: - Table view data source

extension DeviceSelectionTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellType: DeviceSelectionTableViewCell.self, forIndexPath: indexPath)
        let item = items[indexPath.row]
        cell.selectionStyle = .none
        
        cell.label.text = item.model.name
        cell.selectedState = item.selectedState
        
        return cell 
    }
}


// MARK: - Table view delegate

extension DeviceSelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        
        let idx = indexPath.row
        
        if selectionStyle == .single {
            // force at least 1 item to be selected at all times
            for (idx, _) in items.enumerated() {
                items[idx].selectedState = .deselected
            }
            items[idx].selectedState = .selected
        } else {
            items[idx].selectedState = selectedItem.selectedState == .selected ? .deselected : .selected
        }
        
       delegate?.selectableTableViewController(viewController: self, didSelectSelection: items[idx])
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
}

extension DeviceSelectionTableViewController: WizardIntroViewControllerDelegate {

    // MARK: - WizardIntroViewControllerDelegate
    
    func viewController(viewController: WizardIntroViewController, didFinishWithDevice device: Device) {
        User.current.devices.append(device)
        refreshDevices(device)
        dismiss(animated: true, completion: nil)
    }
    
}
