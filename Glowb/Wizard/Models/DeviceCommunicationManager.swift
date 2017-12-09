//
//  ParticleSetupCommunicationManager.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/28/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation

enum DeviceType: String {
    case core = "Core"
    case photon = "Photon"
    case electron = "Electron"
}

class DeviceCommunicationManager {
    
    static let ConnectionEndpointAddress = "192.168.0.1"
    static let ConnectionEndpointPortString = "5609"
    static let ConnectionEndpointPort = 5609;
    
    var connection: DeviceConnection?
    
    var connectionCommand: (() -> Void)?
    var completionCommand: ((ResultType<JSON, ConnectionError>) -> Void)?
    
    
    // MARK: Public API
    
    func sendCommand<T: ParticleCommunicable>(_ type: T.Type, completion: @escaping (ResultType<T.ResponseType, ConnectionError>) -> Void) {
        
        runCommand(onConnection: { connection in
            connection.writeString(T.command)
        }, onCompletion: { result in
            switch result {
            case .success(let json):
                if let stuff = T.parse(json) {
                    completion(.success(stuff))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func configureAP(network: Network, completion: @escaping (ResultType<JSON, ConnectionError>) -> Void) {
        runCommand(onConnection: { connection in
            guard let json = network.asJSON,
                let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                let jsonString = String(data: data, encoding: String.Encoding.utf8) else
            {
                completion(.failure(ConnectionError.couldNotConnect))
                return
            }
            let command = String(format: "configure-ap\n%ld\n\n%@", jsonString.count, jsonString)
            connection.writeString(command)
        }, onCompletion: completion)
    }

    func connectAP(completion: @escaping (ResultType<JSON, ConnectionError>) -> Void) {
        runCommand(onConnection: { connection in
            let request: JSON = ["idx":0]
            guard let json = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted),
                let jsonString = String(data: json, encoding: String.Encoding.utf8) else
            {
                completion(.failure(ConnectionError.couldNotConnect))
                return
            }
          
            let command = String(format: "connect-ap\n%ld\n\n%@", jsonString.count, jsonString)
            connection.writeString(command)
        }, onCompletion: completion)
    }

    
    // MARK: Run commands

    private func runCommand(onConnection: @escaping (DeviceConnection) -> Void,
                            onCompletion: @escaping (ResultType<JSON, ConnectionError>) -> Void) {
        
        guard DeviceCommunicationManager.canSendCommandCall() else { return }
        
        completionCommand = onCompletion
        openConnection { connection in
            onConnection(connection)
        }
    }
    
    private func openConnection(withCommand command: @escaping (DeviceConnection) -> Void) {
        let ipAddress = DeviceCommunicationManager.ConnectionEndpointAddress
        let port = DeviceCommunicationManager.ConnectionEndpointPort
        connection = DeviceConnection(withIPAddress: ipAddress, port: port)
        
        connection!.delegate = self;

        connectionCommand = { [unowned self] in
            command(self.connection!)
        }
    }
    
    
    // MARK: Wifi connection
    
    class func canSendCommandCall() -> Bool {
        
        // TODO: refer to original source
        
        if !Wifi.isDeviceConnected(.photon) {
            return false
        }
        
        return true
    }
}


// MARK: - Connection delegate

extension DeviceCommunicationManager: DeviceConnectionDelegate {
    func deviceConnection(connection: DeviceConnection, didReceiveData data: String) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: .allowFragments) as? JSON else {
                completionCommand?(.failure(ConnectionError.jsonParseError))
                return 
            }
            completionCommand?(.success(json))
        }
        catch {
            completionCommand?(.failure(ConnectionError.jsonParseError))
        }
    }
    
    func deviceConnection(connection: DeviceConnection, didUpdateState state: DeviceConnectionState) {
        switch state {
        case .opened:
            connectionCommand?()
        case .openTimeout:
            completionCommand?(.failure(ConnectionError.timeout))
        case .error:
            completionCommand?(.failure(ConnectionError.couldNotConnect))
        default: break
        }
    }
}
