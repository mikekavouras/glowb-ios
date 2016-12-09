//
//  GlowScene.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/8/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import UIKit
import SpriteKit

class TimerProxy {
    weak var target: GlowScene?
    var selector: Selector
    
    init(target: GlowScene, selector: Selector) {
        self.selector = selector
        self.target = target
    }
    
    @objc func timerDidFire(timer: Timer) {
        if let target = target {
            target.perform(selector)
        } else {
            timer.invalidate()
        }
    }
}

class GlowScene: SKScene {
    private var colorIdx = 0
    weak var timer: Timer?
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = .black
        anchorPoint = .init(x: 0.5, y: 0.0)
        addChild(emitterNode)
        emitterNode.particleColorSequence = nil
        
        let timerProxy = TimerProxy(target: self, selector: #selector(self.changeColor))
        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: timerProxy, selector: #selector(TimerProxy.timerDidFire(timer:)), userInfo: nil, repeats: true)
        
        changeColor()
    }
    
    @objc private func changeColor() {
        let brightness = UIScreen.main.brightness
        
        // 0.5 <= alpha <= 0.6 depending on screen brightness
        var alpha = min(brightness, 0.6)
        alpha = max(alpha, 0.5)
    
        let purple = UIColor.glowbGlowPurple.withAlphaComponent(alpha)
        let blue = UIColor.glowbGlowBlue.withAlphaComponent(alpha)
        
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
