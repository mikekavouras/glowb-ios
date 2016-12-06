//
//  WifiChecker.swift
//  ParticleConnect
//
//  Created by Michael Kavouras on 8/30/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

class Wifi {
    
    private let onConnectionHandler: (UIApplicationState) -> Void
    private var foregroundTimer: Timer?
    private var backgroundTimer: Timer?
    
    init(_ connectionBlock: @escaping (UIApplicationState) -> Void) {
        self.onConnectionHandler = connectionBlock
        NotificationCenter.default.addObserver(self, selector: #selector(startMonitoringConnectionInForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

    }
    
    @objc func startMonitoringConnectionInForeground() {
        foregroundTimer?.invalidate()
        foregroundTimer = nil
        foregroundTimer = Timer(timeInterval: 2.5, target: self, selector: #selector(checkDeviceWifiConnection(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(foregroundTimer!, forMode: .commonModes)
    }
    
    func startMonitoringConnectionInBackground() {
        backgroundTimer = Timer(timeInterval: 2.0, target: self, selector: #selector(checkDeviceConnectionForNotification(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(backgroundTimer!, forMode: .commonModes)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.createBackgroundTask { [unowned self] in
            self.backgroundTimer?.invalidate()
        }
    }
    
    func startMonitoringConnection() {
        startMonitoringConnectionInForeground()
        startMonitoringConnectionInBackground()
    }
    
    func stopMonitoringConnectionInForeground() {
        foregroundTimer?.invalidate()
    }
    
    func stopMonitoringConnectionInBackground() {
        backgroundTimer?.invalidate()
    }
    
    func stopMonitoringConnection() {
        stopMonitoringConnectionInForeground()
        stopMonitoringConnectionInBackground()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func checkDeviceConnectionForNotification(timer: Timer) {
        let state = UIApplication.shared.applicationState
        guard state == .background || state == .inactive,
            Wifi.isDeviceConnected(.photon) else { return }

        stopMonitoringConnectionInBackground()
        
        onConnectionHandler(state)
    }
    
    @objc private func checkDeviceWifiConnection(timer: Timer) {
        let state = UIApplication.shared.applicationState
        guard state == .active,
            Wifi.isDeviceConnected(.photon) else { return }
        
        onConnectionHandler(state)
    }
    
    
    // MARK: Helper
    
    class func isDeviceConnected(_ deviceType: DeviceType) -> Bool {
        guard let interfaces = CNCopySupportedInterfaces() else { return false }
        
        for i in 0..<CFArrayGetCount(interfaces){
            let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
            let rec = unsafeBitCast(interfaceName, to: CFString.self)
            
            guard let interfaceData = CNCopyCurrentNetworkInfo(rec) as NSDictionary? else { continue }
            guard let currentSSID = interfaceData["SSID"] as? String else { continue }
            
            if currentSSID.hasPrefix(deviceType.rawValue) {
                return true
            }
        }
        
        return false
    }
}
