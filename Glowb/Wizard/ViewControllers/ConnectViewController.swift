//
//  ConnectViewController.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/28/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit
import UserNotifications

class ConnectViewController: BaseViewController, StoryboardInitializable {
    
    static var storyboardName: StaticString = "Connect"
    
    lazy var wifi: Wifi = {
        return Wifi { [weak self] state in
            self?.onConnectionHandler(state: state)
        }
    }()
    
    var communicationManager: DeviceCommunicationManager?
    
    
    // MARK: Life cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wifi.startMonitoringConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        wifi.stopMonitoringConnectionInForeground()
    }
    
    deinit {
        wifi.stopMonitoringConnection()
    }
    
    
    // MARK: Notification
    
    private func displayLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Device Connected!"
        content.body = "Tap to continue Setup"
        content.sound = UNNotificationSound.default()
    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "ConnectedIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    // MARK: Navigation
    
    func onConnectionHandler(state: UIApplicationState) {
        if state == .background || state == .inactive {
            displayLocalNotification()
        }
        if state == .active {
            wifi.stopMonitoringConnection()
            
            getDeviceID { _ in
                self.getPublicKey { _ in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let networkViewController = SelectNetworkViewController()
                        self.navigationController?.pushViewController(networkViewController, animated: true)
                    }
                }
            }
        }
    }
    
    
    // MARK: -

    private func getDeviceID(completion: @escaping () -> Void) {
        print("GETTING DEVICE INFO...")
        communicationManager = DeviceCommunicationManager()
        communicationManager?.sendCommand(Command.Device.self) { [unowned self] result in
            switch result {
            case .success(let value):
                print(value)
                completion()
            case .failure(let error):
                self.wifi.startMonitoringConnectionInForeground()
                print(error)
            }
        }
    }
    
    private func getPublicKey(completion: @escaping () -> Void) {
        print("GETTING PUBLIC KEY")
        communicationManager = DeviceCommunicationManager()
        communicationManager!.sendCommand(Command.PublicKey.self) { [unowned self] result in
            switch result {
            case .success:
                completion()
            case .failure(let error):
                self.wifi.startMonitoringConnectionInForeground()
                print(error)
            }
        }
    }
}

