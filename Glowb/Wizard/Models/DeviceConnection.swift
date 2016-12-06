 //
//  SetupConnection.swift
//  ParticleConnect
//
//  Created by Mike Kavouras on 8/29/16.
//  Copyright © 2016 Mike Kavouras. All rights reserved.
//

import Foundation
 
typealias JSON = [String:Any]
 
enum ResultType<Value, Err: Error> {
    case success(Value)
    case failure(Err)
}
 
enum ConnectionError: Error {
    case noSpaceAvailable
    case jsonParseError
    case couldNotConnect
}

protocol DeviceConnectionDelegate: class {
    func deviceConnection(connection: DeviceConnection, didReceiveData data: String)
    func deviceConnection(connection: DeviceConnection, didUpdateState state: DeviceConnectionState)
}

enum DeviceConnectionState {
    case opened
    case closed
    case openTimeout
    case error
    case unknown
}

class DeviceConnection: NSObject {
    
    var ipAddress: String = ""
    var port: Int = 0
    
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    var socketTimer: Timer?
    
    var receivedDataBuffer = ""
    var streamState: (input: Bool, output: Bool) = (false, false)
    
    var isOpen: Bool {
        return (true, true) == streamState
    }
    
    weak var delegate: DeviceConnectionDelegate?
    
    
    // MARK: Life cycle
    
    init(withIPAddress ipAddress: String, port: Int) {
        self.ipAddress = ipAddress
        self.port = port
        
        super.init()
        
        initSocket()
    }
    
    deinit {
        close()
    }
    
    // should throw stream error if not inited
    private func initSocket() {
        
        Stream.getStreamsToHost(withName: ipAddress, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = inputStream,
            let outputStream = outputStream else { return }
        
        [inputStream, outputStream].forEach { stream in
            stream.delegate = self
            stream.open()
            stream.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        
        socketTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.socketOpenTimeoutHandler(timer:)), userInfo: nil, repeats: false)
        
        RunLoop.current.add(socketTimer!, forMode: .defaultRunLoopMode)
    }
    
    func socketOpenTimeoutHandler(timer: Timer) {
        timer.invalidate()
        delegate?.deviceConnection(connection: self, didUpdateState: .openTimeout)
    }
    
    func writeString(_ string: String) {
        guard isOpen,
            let buffer = string.data(using: .utf8, allowLossyConversion: true),
            let outputStream = outputStream else {
                delegate?.deviceConnection(connection: self, didUpdateState: .error)
                return
        }

        DispatchQueue.main.async { [unowned self] in
            print("we got room??? \(outputStream.hasSpaceAvailable)")
            if outputStream.hasSpaceAvailable {
                let _ = buffer.withUnsafeBytes { outputStream.write($0, maxLength: buffer.count) }
            } else {
                self.delegate?.deviceConnection(connection: self, didUpdateState: .error)
            }
        }
    }
    
    private func close() {
        socketTimer?.invalidate()
        
        outputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        outputStream?.close()
        
        inputStream?.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        inputStream?.close()
    }
}


// MARK: Stream delegate

extension DeviceConnection: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .openCompleted {
            
            if aStream == inputStream {
                streamState = (true, streamState.output)
            }
            if aStream == outputStream {
                streamState = (streamState.input, true)
            }
            
            if case (true, true) = streamState {
                delegate?.deviceConnection(connection: self, didUpdateState: .opened)
                socketTimer?.invalidate()
            }
            return
        }

        if eventCode == .hasSpaceAvailable || eventCode == .hasBytesAvailable {
            guard let inputStream = inputStream else { return }
            if aStream == inputStream {
                var buffer = [UInt8](repeatElement(0, count: 1024))
                while inputStream.hasBytesAvailable {
                    let len = inputStream.read(&buffer, maxLength: buffer.count)
                    if let data = String(bytesNoCopy: &buffer, length: len, encoding: .ascii, freeWhenDone: false) {
                        receivedDataBuffer.append(data)
                    }
                }
            }
            return
        }
        
        if eventCode == .endEncountered {
            if aStream == outputStream {
                streamState = (streamState.input, false)
            }
            if aStream == inputStream {
                streamState = (false, streamState.output)
                if case (_, true) = streamState {
                    outputStream?.close()
                }
                delegate?.deviceConnection(connection: self, didUpdateState: .closed)
                if !receivedDataBuffer.isEmpty {
                    delegate?.deviceConnection(connection: self, didReceiveData: receivedDataBuffer)
                }
            }
            return
        }
        
        if eventCode == .errorOccurred {
            delegate?.deviceConnection(connection: self, didUpdateState: .error)
            return
        }
    }
}
