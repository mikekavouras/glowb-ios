//
//  SettingsViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController { // BaseTableViewController {
    
    // MARK: - Properties
    // MARK: -
    
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Life cycle
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        User.current.fetchDevices().then { devices -> Void in
            self.tableView.reloadData()
        }.catch { error in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Setup
    // MARK: -
    
    private func setup() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        setupTableView()
        setupNavigationItem()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        title = "Settings"
    }
    
    
    // MARK: - Actions
    // MARK: -
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Table view data source
// MARK: -

extension SettingsViewController: UITableViewDataSource { 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.current.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = User.current.devices[indexPath.row]
        
        // explicit themeing = not hot
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        
        cell.textLabel?.text = device.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Devices"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightBold)
        label.frame.origin.x = 15.0
        label.textColor = .white
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let view = UIView()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15.0)
            make.trailing.equalToSuperview().offset(-15.0)
        }
        return view
    }
}


// MARK: - Table view delegate
// MARK: - 

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = User.current.devices[indexPath.row]
        let viewController = DeviceDetailViewController()
        viewController.device = device
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: Are you shur????
        let device = User.current.devices[indexPath.row]
        User.current.deleteDevice(device).then { _ in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }.catch { error in
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
