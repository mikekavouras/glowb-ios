//
//  SoundLibrary.swift
//  Glowb
//
//  Created by Michael Kavouras on 3/12/17.
//  Copyright © 2017 Michael Kavouras. All rights reserved.
//

import AVFoundation

enum Sound {
    case popIn
    case popOut
}

final class SoundLibrary {
    
    // MARK: - Public
    // MARK: - 
    
    static let shared = SoundLibrary()
    
    func play(_ sound: Sound) {
        DispatchQueue.global(qos: .background).async {
            switch sound {
            case .popIn:
                self.popInPlayer?.play()
            case .popOut:
                self.popOutPlayer?.play()
            }
        }
    }

    static func initialize() {
        _ = shared
    }
    
    // MARK: - Private
    // MARK: - 
    
    private let popInPlayer: AVAudioPlayer? = {
        return SoundLibrary.generateAudioPlayer("pop_in")
    }()
    
    private let popOutPlayer: AVAudioPlayer? = {
        return SoundLibrary.generateAudioPlayer("pop_out")
    }()
    
    private static func generateAudioPlayer(_ fileName: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "wav") else { return nil }
        let url = URL(fileURLWithPath: path)
        let player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
        return player
    }
    
}
