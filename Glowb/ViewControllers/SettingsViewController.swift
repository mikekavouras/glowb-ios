//
//  SettingsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class SettingsViewController: BaseTableViewController {
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        User.current.fetchDevices().then { devices -> Void in
            self.tableView.reloadData()
        }.catch { error in
            print(error)
        }
    }
    
    
    // MARK: - Setup
    
    private func setup() { setupTableView()
        setupNavigationItem()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        title = "Devices"
    }
    
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.current.devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = User.current.devices[indexPath.row]
        
        // explicit themeing = not hot
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        
        cell.textLabel?.text = device.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = User.current.devices[indexPath.row]
        let viewController = DeviceDetailViewController()
        viewController.device = device
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit")
        
        // delete device
        // reload table
    }
    
    
}
