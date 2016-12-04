//
//  RelationshipViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class RelationshipViewController: BaseTableViewController {

    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: Setup
    
    private func setup() {
        setupNavigationItem()
        setupTableView()
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupTableView() {
        tableView.register(cellType: TextViewTableViewCell.self)
    }
    
    
    // MARK: Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        print("SAVE RELATIONSHIP")
    }
    
    
    // MARK: Utility
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


// MARK: - Table view data source


extension RelationshipViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusable(cellType: TextViewTableViewCell.self, forIndexPath: indexPath)
        cell.textField.autocapitalizationType = .words
        cell.label.text = "Name"
        
        return cell
    }
    
}
