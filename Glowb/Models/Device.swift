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
struct Device: Mappable, Equatable {
    var name: String
    var particleId: String = ""
    var id: Int = 0
    var presence: Bool = false
    let connectionStatus: DeviceConnectionStatus = .disconnected
    
    init(name: String, id: Int, particleId: String) {
        self.name = name
        self.id = id
        self.particleId = particleId
    }
    
    init?(map: Map) {
        guard let userDeviceId = map.JSON["id"] as? Int,
            let name = map.JSON["name"] as? String,
            let device = map.JSON["device"] as? JSON else
        { return nil }
        
        self.name = name
        self.id = userDeviceId
        self.presence = (device["presence"] as? Bool) ?? false
        self.particleId = (device["particle_id"] as? String) ?? ""
    }
    
    mutating func mapping(map: Map) {
        name       <- map["name"]
        id         <- map["id"]
        particleId <- map["particle_id"]
        presence   <- map["presence"]
    }
    
    
    // MARK: - API
    // MARK: - 
    
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
    
    func update() -> Promise<Device> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.updateDevice(self.id, name)).validate().responseJSON { response in
                let result = DeviceParser.parseResponse(response)
                
                switch result {
                case .success(let device):
                    let newDevice = Device(name: device.name, id: device.id, particleId: device.particleId)
                    let newDevices = User.current.devices.filter { $0 != self }
                    User.current.devices = newDevices + [device]
                    fulfill(newDevice)
                case.failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    func delete() -> Promise<Void> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.deleteDevice(self.id)).validate().response { response in
                guard let urlResponse = response.response,
                    urlResponse.statusCode == 200 else
                {
                    reject(DeviceError.failedToDelete)
                    return
                }
                
                fulfill(())
            }
        }
    }
}

func ==(lhs: Device, rhs: Device) -> Bool {
    return lhs.id == rhs.id
}

private struct DevicesParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<[Device]> {
        guard let data = json["user_devices"] as? [JSON] else {
            return .failure(ServerError.invalidJSONFormat)
        }
        
        let devices: [Device] = data.flatMap { Mapper<Device>().map(JSON: $0) }
        return .success(devices)
    }
}

struct DeviceParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Device> {
        guard let device = Mapper<Device>().map(JSON: json) else {
            return .failure(DeviceError.failedToParse)
        }
        
        return .success(device)
    }
}
