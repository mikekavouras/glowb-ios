//
//  Target.swift
//  TeeStyles
//
//  Created by Bogdan Vitoc on 8/26/16.
//  Copyright © 2016 Teespring. All rights reserved.
//
import Foundation

internal enum TargetType {
    case device
    case simulator
    case interfaceBuilder
}

internal struct Target {
    
    static var current: TargetType {
        var target = TargetType.device
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            target = .simulator
        #endif
        
        #if TARGET_INTERFACE_BUILDER
            target = .interfaceBuilder
        #endif
        
        return target
    }
    
}
