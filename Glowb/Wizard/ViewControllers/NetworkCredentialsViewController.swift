//
//  NetworkCredentialsViewController.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 8/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class NetworkCredentialsViewController: BaseViewController, StoryboardInitializable {
    
    var network: Network!
    
    static var storyboardName: StaticString = "NetworkCredentials"
    
    
    @IBOutlet private weak var networkNameLabel: PrimaryTextLabel!
    @IBOutlet private weak var passwordTextField: BaseTextField!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        networkNameLabel.text = network.ssid
    }
    
    
    // MARK: - Actions
    
    @IBAction func toggleSecurePassword(_ sender: UISwitch) {
        passwordTextField.isSecureTextEntry = sender.isOn
    }
}

extension NetworkCredentialsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            network.password = text
        }
        let viewController = ConnectingProgressViewController()
        viewController.network = network
        navigationController?.pushViewController(viewController, animated: true)
        return true
    }
}
