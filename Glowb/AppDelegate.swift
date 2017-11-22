//
//  AppDelegate.swift
//  Glowb
//
//  Created by Michael Kavouras on 11/30/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setup(application)
        registerUser()
        
        return true
    }
    
    
    // MARK: - Backgrounding
    
    var backgroundTask: UIBackgroundTaskIdentifier? = nil
    
    func createBackgroundTask(withExpirationHandler handler: () -> Void) {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [unowned self] handler in
            handler
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
    }
    
    
    // MARK: - Notifications
    
    static func registerNotifications() {
        registerUINotifications()
        registerAllRemoteNotifications()
    }
    
    private static func registerUINotifications () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
        }
    }
    
    private static func registerAllRemoteNotifications () {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    // MARK: - User
    
    private func registerUser() {
        User.current.register()
    }
    
    
    // MARK: - Setup
    
    private func setup(_ application: UIApplication) {
        setupStyles(application)
        SoundLibrary.initialize()
    }
    
    private func setupStyles(_ application: UIApplication) {
        setupNavigationBar()
        application.isStatusBarHidden = true
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).shadowImage = UIImage()
        UINavigationBar.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).tintColor = .white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.white
        ], for: .normal)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [BaseNavigationController.self]).setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)
        ], for: .disabled)
    }
}

