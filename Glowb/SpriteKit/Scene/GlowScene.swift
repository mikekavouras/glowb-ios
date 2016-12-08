//
//  GlowScene.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import SpriteKit

class GlowScene: SKScene {
    private var colorIdx = 0
    var timer: Timer?
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = .black
        anchorPoint = .init(x: 0.5, y: 0.0)
        addChild(emitterNode)
        emitterNode.particleColorSequence = nil
        
        timer = Timer(timeInterval: 10.0, target: self, selector: #selector(changeColor), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
        
        changeColor()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func changeColor() {
//        let brightness = UIScreen.main.brightness
        let alpha: CGFloat = 0.7
        let purple = UIColor(red: 62/255.0, green: 32/255.0, blue: 89/255.0, alpha: alpha)
        let blue = UIColor(red: 25/255.0, green: 67/255.0, blue: 128/255.0, alpha: alpha)
        
        let colors = [purple, blue]
        let idx = colorIdx % colors.count
        
        colorIdx += 1
        
        emitterNode.particleColor = colors[idx]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emitterNode: SKEmitterNode =  SKEmitterNode(fileNamed: "Glow")!
}
