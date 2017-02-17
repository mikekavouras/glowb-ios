//
//  DeviceDetailViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class DeviceDetailViewController: BaseTableViewController {
    
    var device: Device!

    
    // MARK: - Life cycle
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: - Setup
    // MARK: -
    
    private func setup() {
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDeviceTapped))
    }
    
    private func setupTableView() {
        tableView.register(cellType: TextFieldTableViewCell.self)
        tableView.register(cellType: SingleActionTableViewCell.self)
    }
    
    
    // MARK: - Actions
    // MARK: - 
    
    private func displayShare(for invite: Invite) {
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
    
    
    // MARK: - Table view data source
    // MARK: -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusable(cellType: TextFieldTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = "Name:"
            cell.textField.text = device.name
            cell.textField.textAlignment = .left
            cell.textField.delegate = self
            cell.textField.clearButtonMode = .whileEditing
            cell.textField.autocapitalizationType = .sentences
            return cell
        case 1:
            let cell = tableView.dequeueReusable(cellType: SingleActionTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = "Create an invite"
            return cell
        case 2: 
            let cell = tableView.dequeueReusable(cellType: SingleActionTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = "Delete"
            cell.actionType = .destructive
            return cell
        default: return UITableViewCell()
        }
    }

    
    // MARK: - Table view delegate
    // MARK: - 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! TextFieldTableViewCell
            cell.textField.becomeFirstResponder()
        case 1:
            Invite.create(deviceId: device.id).then { invite in
                self.displayShare(for: invite)
            }.catch { error in
                print(error)
            }
        case 2:
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
