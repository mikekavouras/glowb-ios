//
//  DeviceDetailViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceDetailViewController: BaseViewController {
    
    var device: Device!
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)

    
    // MARK: - Life cycle
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: - Setup
    // MARK: -
    
    private func setup() {
        view.backgroundColor = UIColor.clear
        
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDeviceTapped))
        title = device.name
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    // MARK: - Actions
    // MARK: - 
    
    fileprivate func displayShare(for invite: Invite) {
        let text = "You're invited!"
        let activityItems = [text as AnyObject, invite.token as AnyObject]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @objc private func saveDeviceTapped() {
        view.endEditing(true)
        
        device.update().then { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }.catch { error in
            print(error)
        }
    }
}

    
// MARK: - Table view data source
// MARK: -

extension DeviceDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = "Create an invite"
            cell.textLabel?.textColor = .white
            return cell
        case 1: 
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = "Delete"
            cell.textLabel?.textColor = .white
            return cell
        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Create an invite? 👋" }
        return "Delete this device?"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
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

extension DeviceDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            Invite.create(deviceId: device.id).then { invite in
                self.displayShare(for: invite)
            }.catch { error in
                print(error)
            }
        case 1:
            User.current.deleteDevice(device).then { _ in
                _ = self.navigationController?.popViewController(animated: true)
            }.catch { error in
                print(error)
            }
        default: break
        }
    }
}


// MARK: - Text file delegate
// MARK: - 

extension DeviceDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            device.name = text
        }
    }
}
