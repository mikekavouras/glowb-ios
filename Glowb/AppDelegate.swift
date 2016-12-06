//
//  AppDelegate.swift
//  Glowb
//
//  Created by Michael Kavouras on 11/30/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        
        return true
    }
    
    
    // MARK: - Setup
    
    private func setup() {
       setupStyles()
    }
    
    private func setupStyles() {
       setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).tintColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).setTitleTextAttributes([
            NSForegroundColorAttributeName: UIColor.white
        ], for: .normal)
    }
}

