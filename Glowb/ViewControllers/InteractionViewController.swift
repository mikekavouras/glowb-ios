//
//  InteractionViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

class InteractionViewController: BaseTableViewController, StoryboardInitializable {
    
    static var storyboardName: StaticString = "Interaction"

    @IBOutlet weak var previewImageView: UIImageView!
    var interaction = Interaction()
    
    lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        picker.view.backgroundColor = UIColor.white
        picker.navigationBar.isTranslucent = false
        picker.navigationBar.tintColor = UIColor.black
        picker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        
        return picker
    }()
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
    }
    
    
    // MARK: Setup
    
    private func setup() {
        setupNavigationItem()
        setupTableView()
        setupImageView()
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupTableView() {
        tableView.register(cellType: TextFieldTableViewCell.self)
        tableView.register(cellType: TextSelectionRepresentableTableViewCell.self)
        tableView.register(cellType: ColorSelectionRepresentableTableViewCell.self)
    }
    
    private func setupImageView() {
        previewImageView.layer.cornerRadius = 13.0
        _ = imagePickerController // eager load
    }
    
    // MARK: Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        print("SAVE RELATIONSHIP")
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    fileprivate func showDevicesViewController() {
        let devices: [Device] = []
        let selectableDevices = devices.map { SelectableViewModel(model: $0, selectedState: .deselected) }
        let viewController = DeviceSelectionTableViewController(items: selectableDevices, configure: { (cell: TextSelectionRepresentableTableViewCell, item) in
            cell.label.text = item.model.name
        })
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    fileprivate func showColorsViewController() {
        let colors = [Color(.red), Color(.green), Color(.blue)]
        let selectableColors = colors.map { color -> SelectableViewModel<Color> in
            var state: SelectedState = .deselected
            if let rColor = interaction.color {
                state = color == rColor ? .selected : .deselected
            }
            return SelectableViewModel(model: color, selectedState: state)
        }
        let viewController = SelectableTableViewController(items: selectableColors, configure: { (cell: ColorSelectionTableViewCell, item) in
            cell.color = item.model.color
            cell.selectedState = item.selectedState
        })
        viewController.selectionStyle = .single
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - Table view data source

extension InteractionViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusable(cellType: TextFieldTableViewCell.self, forIndexPath: indexPath)
            cell.textField.autocapitalizationType = .words
            cell.textField.delegate = self
            cell.label.text = "Name"
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusable(cellType: TextSelectionRepresentableTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = "Select device"
            cell.selectionLabel.text = ""
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = tableView.dequeueReusable(cellType: ColorSelectionRepresentableTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = "Select color"
            cell.accessoryType = .disclosureIndicator
            cell.color = interaction.color?.color
            return cell
        default: return UITableViewCell()
        }
    }
}


// MARK: - Table view delegate

extension InteractionViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            showDevicesViewController()
        case 2:
            showColorsViewController()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
}


// MARK: - Text field delegate

extension InteractionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: - Image picker controller delegate

extension InteractionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        previewImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Selectable table view controller delegate

extension InteractionViewController: SelectableTableViewControllerDelegate {
    func selectableTableViewController(viewController: UITableViewController, didSelectSelection selection: Selectable) {
        if let selection = selection as? SelectableViewModel<Color> {
            interaction.color = selection.model
        }
        
        if let selection = selection as? SelectableViewModel<Device> {
            interaction.device = selection.model
        }
        
        tableView.reloadData()
    }
}
