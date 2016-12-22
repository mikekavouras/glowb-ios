//
//  ViewController.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/28/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

protocol WizardIntroViewControllerDelegate: class {
    func viewController(viewController: WizardIntroViewController, didFinishWithDevice device: Device)
}

class WizardIntroViewController: BaseViewController, StoryboardInitializable {
    
    var delegate: WizardIntroViewControllerDelegate?
    
    static var storyboardName: StaticString = "WizardIntro"
    
    @IBAction func redeemInviteButtonTapped(_ sender: Any) {
        displayRedeemUI()
    }
    
    private func displayRedeemUI() {
       let alertController = UIAlertController(title: "Redeem", message: "Enter your invite code", preferredStyle: .alert)
        
        let codeTextField = { (textField: UITextField) -> Void in
            textField.placeholder = "Enter code"
        }
        
        let nameTextField = { (textField: UITextField) -> Void in
            textField.placeholder = "Name (e.g. Mom's living room)"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { action in
            if let textFields = alertController.textFields,
                let codeField = textFields.first,
                let nameField = textFields.last,
                let code = codeField.text,
                let name = nameField.text
            {
                Invite.claim(name: name, code: code).then { device in
                    self.delegate?.viewController(viewController: self, didFinishWithDevice: device)
                }.catch { error in
                    self.displayErrorUI(error: error)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addTextField(configurationHandler: codeTextField)
        alertController.addTextField(configurationHandler: nameTextField)
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func displayErrorUI(error: Error) {
        // TODO: Better error messaging
        let alertController = UIAlertController(title: "Error", message: "There was an error", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default) { action in
            self.displayRedeemUI()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        
        AppDelegate.registerNotifications()
        
        let connectController = ConnectViewController.initFromStoryboard()
        navigationController?.pushViewController(connectController, animated: true)
    }
}

