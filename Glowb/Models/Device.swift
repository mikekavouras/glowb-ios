//
//  Device.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/5/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Alamofire
import PromiseKit
import ObjectMapper

enum DeviceConnectionStatus {
    case connected
    case disconnected
}

enum DeviceError: Error {
    case failedToParse
    case failedToDelete
} 
struct Device: Mappable {
    var name: String
    var particleId: String
    var id: String
    let connectionStatus: DeviceConnectionStatus = .disconnected
    
    init?(map: Map) {
        guard let attributes = map.JSON["attributes"] as? JSON else { return nil }
        guard let userDeviceId = map.JSON["id"] as? String else { return nil }
        
        guard let name = attributes["name"] as? String,
            let device = attributes["device"] as? JSON,
            let particleId = device["particle_id"] as? String else
        { return nil }
        
        self.name = name
        self.id = userDeviceId
        self.particleId = particleId
    }
    
    mutating func mapping(map: Map) {
        name       <- map["attributes.name"]
        particleId <- map["attributes.device.particleId"]
        id         <- map["id"]
    }
    
    
    // MARK: - API
    
    static func fetchAll() -> Promise<[Device]> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.getDevices).validate().responseJSON { response in
                let result = DevicesParser.parseResponse(response)
                
                switch result {
                case .success(let devices):
                    fulfill(devices)
                case.failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func create(deviceId: String, name: String) -> Promise<Device> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.createDevice(deviceId, name)).validate().responseJSON { response in
                let result = DeviceParser.parseResponse(response)
                
                switch result {
                case .success(let devices):
                    fulfill(devices)
                case.failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func delete() -> Promise<Void> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.deleteDevice(self.id)).validate().responseJSON { response in
                if response.result.isSuccess {
                    fulfill()
                } else {
                    reject(DeviceError.failedToDelete)
                }
            }
        }
    }
}

private struct DevicesParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<[Device]> {
        if let data = json["data"] as? [JSON] {
            let devices: [Device] = data.flatMap { Mapper<Device>().map(JSON: $0) }
            return .success(devices)
        } else {
            return .failure(DeviceError.failedToParse)
        }
    }
}

private struct DeviceParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Device> {
        if let data = json["data"] as? JSON,
            let device = Mapper<Device>().map(JSON: data)
        {
            return .success(device)
        } else {
            return .failure(DeviceError.failedToParse)
        }
    }
}
