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
    var particleId: String = ""
    var id: Int
    let connectionStatus: DeviceConnectionStatus = .disconnected
    
    init?(map: Map) {
        guard let userDeviceId = map.JSON["id"] as? Int,
            let name = map.JSON["name"] as? String else
        { return nil }
        
        self.name = name
        self.id = userDeviceId
    }
    
    mutating func mapping(map: Map) {
        name       <- map["name"]
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
        guard let data = json["user_devices"] as? [JSON] else {
            return .failure(ServerError.invalidJSONFormat)
        }
        
        let devices: [Device] = data.flatMap { Mapper<Device>().map(JSON: $0) }
        return .success(devices)
    }
}

private struct DeviceParser: ServerResponseParser {
    static func parseJSON(_ json: JSON) -> Alamofire.Result<Device> {
        guard let device = Mapper<Device>().map(JSON: json) else {
            return .failure(DeviceError.failedToParse)
        }
        
        return .success(device)
    }
}
