//
//  NetworkCredentialsViewController.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 8/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class NetworkCredentialsViewController: BaseViewController {
    
    var network: Network!
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(network)
        setup()
    }

    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        textField = UITextField()
        textField.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        textField.center = view.center
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "enter password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.returnKeyType = .join
        textField.delegate = self
        view.addSubview(textField)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30)
        label.center = view.center
        label.frame.origin.y -= 40
        label.text = network.ssid
        label.textAlignment = .center
        view.addSubview(label)
        
        let secureToggle = UISwitch()
        secureToggle.isOn = true
        secureToggle.frame.origin.y = textField.frame.origin.y + textField.frame.size.height + 10
        secureToggle.frame.origin.x = textField.frame.origin.x
        secureToggle.addTarget(self, action: #selector(toggleSecureToggle(toggle:)), for: .valueChanged)
        view.addSubview(secureToggle)
    }
    
    @objc private func toggleSecureToggle(toggle: UISwitch) {
        textField.isSecureTextEntry = toggle.isOn
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
