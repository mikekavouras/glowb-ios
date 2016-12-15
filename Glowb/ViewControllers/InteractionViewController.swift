//
//  InteractionViewController.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/3/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import AlamofireImage

class InteractionViewController: BaseTableViewController, StoryboardInitializable {
    
    static var storyboardName: StaticString = "Interaction"

    var interaction: Interaction!
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    
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
        if interaction == nil {
            interaction = Interaction()
        }
    
        setupNavigationItem()
        setupTableView()
        setupImageView()
        
        User.current.fetchDevices().catch { error in
            print(error)
        }
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
        if let url = interaction.imageUrl {
            previewImageView.af_setImage(withURL: url)
        }
        _ = imagePickerController // eager load
    }
    
    // MARK: Actions
    
    @objc private func cancelButtonTapped() {
        // TODO: Alert (u shur?)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        // TODO: Validation
        
        if interaction.id == nil {
            createInteraction()
        } else {
            updateInteraction()
        }
        
    }
    
    private func createInteraction() {
        Interaction.create(interaction).then { interaction -> Void in
            User.current.interactions.append(interaction)
            self.dismiss(animated: true, completion: nil)
        }.catch { error in
            print(error)
        }
    }
    
    private func updateInteraction() {
        Interaction.update(interaction).then { interaction -> Void in
            if let idx = (User.current.interactions.index { $0 == interaction } ) {
                User.current.interactions[idx] = interaction
                self.dismiss(animated: true, completion: nil)
            }
        }.catch { error in
            print(error)
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    fileprivate func showDevicesViewController() {
        let devices = User.current.devices
        let selectableDevices = devices.map { item -> SelectableViewModel<Device> in
            var state: SelectedState = .deselected
            if let device = interaction.device {
                state = item == device ? .selected : .deselected
            }
            return SelectableViewModel(model: item, selectedState: state)
        }

        let viewController = DeviceSelectionTableViewController(items: selectableDevices, configure: { (cell: DeviceSelectionTableViewCell, item) in
            cell.label.text = item.model.name
            cell.selectedState = item.selectedState
        })

        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
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
            cell.textField.text = interaction.name
            return cell
        case 1:
            let cell = tableView.dequeueReusable(cellType: TextSelectionRepresentableTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = interaction.device == nil ? "Select device" : "Device"
            cell.selectionLabel.text = interaction.device?.name
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = tableView.dequeueReusable(cellType: ColorSelectionRepresentableTableViewCell.self, forIndexPath: indexPath)
            cell.label.text = interaction.color == nil ? "Select color" : "Color"
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
        case 0:
            if let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell {
                cell.textField.becomeFirstResponder()
            }
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            interaction.name = text
        }
    }
}


// MARK: - Image picker controller delegate

extension InteractionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if let finalImage = image.scale(amount: 2000 / image.size.width) {
            previewImageView.image = finalImage
            uploadImage(finalImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func uploadImage(_ image: UIImage) {
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        uploadProgressView.progress = 0.0
        UIView.animate(withDuration: 0.3) {
            self.uploadProgressView.alpha = 1.0
        }
        
        _ = Photo.create(image: image, uploadProgressHandler: handleUploadProgress).then { [weak self] photo -> Void in
            self?.interaction.photo = photo
        }.catch { error -> Void in
            print(error)
        }.always {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.uploadProgressView.alpha = 0.0
            }
        }
    }
    
    private func handleUploadProgress(_ progress: Progress) {
        uploadProgressView.progress = Float(progress.fractionCompleted)
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
        
        _ = navigationController?.popViewController(animated: true)
        
        tableView.reloadData()
    }
}
