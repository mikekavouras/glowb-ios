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
    var deviceId: String!
    
    fileprivate var state: ProgressState = .configureCredentials
    fileprivate var communicationManager: DeviceCommunicationManager? = DeviceCommunicationManager()

    fileprivate var needsToClaimDevice = false
    fileprivate var isAPIReachable = false
    fileprivate var isHostReachable = false
    fileprivate var hostReachability = Reachability(hostName: "https://api.particle.io")
    
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .configureCredentials
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: Notification.Name.ReachabilityChanged, object: nil)
       
        hostReachability?.startNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.hidesBackButton = true
        
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("a")
        configureDeviceNetworkCredentials {
            print("c")
            self.connectDeviceToNetwork {
                print("e")
                self.waitForCloudConnection {
                    print("g")
                    self.checkForInternetConnectivity()
                }
            }
        }
    }
    
    
    // MARK: Connecting
    
    private func configureDeviceNetworkCredentials(completion: @escaping () -> Void) {
        print("b")
        communicationManager = DeviceCommunicationManager()
        communicationManager?.configureAP(network: network) { [unowned self] result in
            self.communicationManager = nil
            completion()
        }
    }
    
    private func connectDeviceToNetwork(completion: @escaping () -> Void) {
        print("d")
        communicationManager = DeviceCommunicationManager()
        communicationManager?.connectAP { [unowned self] result in
            self.communicationManager = nil
            
            var retries = 0
            
            func connect() {
                if Wifi.isDeviceConnected(.photon) == true && retries < 10 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        retries += 1
                        connect()
                    }
                } else {
                    // TODO: Handle error case (never connected)
                    completion()
                }
            }
            
            connect()
        }
    }
    
    private func waitForCloudConnection(completion: @escaping () -> Void) {
        print("f")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            completion()
        }
    }
    
    private func checkForInternetConnectivity() {
        print("h")
        
        var retries = 0
        func connect() {
            print("trying to connect")
            if !isHostReachable && retries < 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    retries += 1
                    connect()
                }
            } else {
                if isHostReachable {
                    print("IT'S ALL DONE WE DID IT!")
                    displayNameInputUI() { name in
                        let userInfo = [ "device_id" : self.deviceId, "device_name" : name ]
                        NotificationCenter.default.post(name: .particleDeviceConnected, object: nil, userInfo: userInfo)
                    }
                } else {
                    print("this shit failed")
                }
            }
        }
        
        connect()
    }
    
    
    // MARK: -
    
    @objc private func reachabilityChanged(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else { return }
        let status = reachability.currentReachabilityStatus()
        
        print("Reachability changed: \(status.rawValue)")
        
        isHostReachable = status.rawValue == 1 || status.rawValue == 2
    }
    
    // MARK: - 
    
    private func displayNameInputUI(completion: @escaping (String) -> Void) {
       let alertController = UIAlertController(title: "Connected!", message: "Name your device", preferredStyle: .alert)
        
        let nameTextField = { (textField: UITextField) -> Void in
            textField.placeholder = "Name (e.g. living room)"
        }
        
        let submitAction = UIAlertAction(title: "Finish", style: .default) { action in
            if let textFields = alertController.textFields,
                let nameField = textFields.last,
                let name = nameField.text
            {
                completion(name)
            }
        }
        
        alertController.addTextField(configurationHandler: nameTextField)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
