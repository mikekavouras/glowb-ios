//
//  ViewController.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/28/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

class WizardIntroViewController: BaseViewController, StoryboardInitializable {
    
    static var storyboardName: StaticString = "WizardIntro"
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        
        AppDelegate.registerNotifications()
        
        let connectController = ConnectViewController()
        let navController = UINavigationController(rootViewController: connectController)
        present(navController, animated: true, completion: nil)
    }
}

