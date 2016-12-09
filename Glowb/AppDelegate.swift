//
//  AppDelegate.swift
//  Glowb
//
//  Created by Michael Kavouras on 11/30/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import UserNotifications

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
        User.current.register().then { token in
            User.current.accessToken = token
        }.catch { error in
            print(error)
        }
    }
    
    
    // MARK: - Setup
    
    private func setup(_ application: UIApplication) {
        setupStyles(application)
    }
    
    private func setupStyles(_ application: UIApplication) {
        setupNavigationBar()
        application.isStatusBarHidden = true
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

