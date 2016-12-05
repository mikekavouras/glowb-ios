//
//  SelectableTableViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

enum SelectionStyle {
    case single
    case multiple
}

class SelectableTableViewController<Item: Selectable, Cell: UITableViewCell>: UITableViewController {
    
    var selectionStyle: SelectionStyle = .single
    
    private let cellIdentifier = "Cell"
    private var items: [Item]
    private let configure: (Cell, Item) -> ()
    
    
    // MARK: - Life cycle
    
    init(items: [Item], configure: @escaping (Cell, Item) -> ()) {
        self.items = items
        self.configure = configure
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
        let item = items[indexPath.row]
        cell.selectionStyle = .none
        
        configure(cell, item)
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionStyle == .single {
            for var item in items {
                item.selected = false
            }
        }
        
        var selectedItem = items[indexPath.row]
        items[indexPath.row].selected = !selectedItem.selected
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
