//
//  SelectNetworkViewController.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class SelectNetworkViewController: BaseTableViewController {
    
    var deviceId: String!
    
    fileprivate var communicationManager: DeviceCommunicationManager? = DeviceCommunicationManager()
    fileprivate var networks: [Network] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.viewControllers = [self]
    }
    
    
    // MARK: Setup
    
    private func setup() {
        setupTableView()
        setupNavigationItem()
        
        scanForNetworks {
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.register(cellType: WiFiTableViewCell.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupNavigationItem() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Select a Network"
    }

    
    // MARK: UIRefreshControl
    
    @objc private func handleRefreshControl() {
        scanForNetworks { [unowned self] in
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Scan
    
    private func scanForNetworks(completion: @escaping () -> Void) {
        // TODO: Retry logic
        communicationManager = DeviceCommunicationManager()
        communicationManager?.sendCommand(Command.ScanAP.self) { result in
            switch result {
            case .success(let list):
                self.networks = list
                completion()
            case .failure(let error):
                print(error)
            }
            self.communicationManager = nil
        }
    }
}


// MARK: - Table view data source

extension SelectNetworkViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellType: WiFiTableViewCell.self, forIndexPath: indexPath)
        cell.networkNameLabel.text = networks[indexPath.row].ssid
        return cell
    }
}


// MARK: - Table view delegate

extension SelectNetworkViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = networks[indexPath.row]
        let viewController = NetworkCredentialsViewController.initFromStoryboard()
        
        viewController.network = network
        viewController.deviceId = deviceId
        
        // TODO: Handle passwordless network
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
}
