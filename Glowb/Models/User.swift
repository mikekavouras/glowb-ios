//
//  User.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/6/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit

struct User {
    static var current = User()
    
    var accessToken: String? {
        get {
            return AccessToken.current
        }
        set {
            AccessToken.current = newValue
        }
    }
    
    private var isRegistered: Bool {
        return accessToken != nil
    }
    
    func register() {
        
        if isRegistered { return }
        
        AccessToken.create().then { token -> Void in
            AccessToken.current = token
        }.catch { error in
            print(error)
        }
        
    }
    
    
    // MARK: Interactions
    
    var interactions: [Interaction] = []
    
    func fetchInteractions() -> Promise<[Interaction]> {
        return Promise { fulfill, reject in
            Interaction.fetchAll().then { interactions -> Void in
                User.current.interactions = interactions
                fulfill(interactions)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    
    // MARK: Devices
    
    var devices: [Device] = []
    
    @discardableResult
    func fetchDevices() -> Promise<[Device]> {
        return Promise { fulfill, reject in
            Device.fetchAll().then { devices -> Void in
                User.current.devices = devices
                fulfill(devices)
            }.catch { error in
                reject(error)
            }
        }
    }
}
