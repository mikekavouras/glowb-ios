//
//  ConnectingProgressViewController.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 9/5/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let ReachabilityChanged = Notification.Name("kNetworkReachabilityChangedNotification")
}

enum ProgressState {
    case configureCredentials
    case connectToWifi
    case waitForCloudConnection
    case checkInternetConnectivity
    case verifyDeviceOwnership
    case last
}


class ConnectingProgressViewController: BaseViewController {

    var network: Network!
    var state: ProgressState = .configureCredentials
    var communicationManager: DeviceCommunicationManager? = DeviceCommunicationManager()

    var needsToClaimDevice = false
    var isAPIReachable = false
    var isHostReachable = false
    var hostReachability = Reachability(hostName: "https://api.particle.io")
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .configureCredentials
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: Notification.Name.ReachabilityChanged, object: nil)
       
        hostReachability?.startNotifier()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureDeviceNetworkCredentials {
            self.connectDeviceToNetwork {
                self.waitForCloudConnection {
                    self.checkForInternetConnectivity()
                }
            }
        }
    }
    
    
    // MARK: Connecting
    
    private func configureDeviceNetworkCredentials(completion: @escaping () -> Void) {
        communicationManager = DeviceCommunicationManager()
        communicationManager?.configureAP(network: network) { [unowned self] result in
            self.communicationManager = nil
            completion()
        }
    }
    
    private func connectDeviceToNetwork(completion: @escaping () -> Void) {
        communicationManager = DeviceCommunicationManager()
        communicationManager?.connectAP { [unowned self] result in
            self.communicationManager = nil
            
            var retries = 0
            while Wifi.isDeviceConnected(.photon) == true && retries < 10 {
                Thread.sleep(forTimeInterval: 2.0)
                retries += 1
            }
            
            completion()
        }
    }
    
    private func waitForCloudConnection(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            completion()
        }
    }
    
    private func checkForInternetConnectivity() {
        var retries = 0
        while !isHostReachable {
            for _ in 0..<5 {
                Thread.sleep(forTimeInterval: 2.0)
                retries += 1
            }
        }
        
        if isHostReachable {
            // done
        } else {
            // didn't work
        }
    }
    
    
    // MARK: -
    
    @objc private func reachabilityChanged(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else { return }
        let status = reachability.currentReachabilityStatus()
        
        isHostReachable = status.rawValue == 1 || status.rawValue == 2
    }
}
