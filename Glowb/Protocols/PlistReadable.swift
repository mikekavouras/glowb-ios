//
//  PlistReadable.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/9/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation

protocol PlistReadable {
    static var plistName: String { get set }
}

extension PlistReadable {
    fileprivate static var plist: NSDictionary? {
        guard let path = Bundle.main.path(forResource: plistName, ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }
    
    fileprivate static func string(_ key: String) -> String? {
        return plist?[key] as? String
    }
    
    static func unsafeString(_ key: String) -> String {
        return (plist?[key] as? String) !! "Unable to find the key [ \(key) ] in the plist [ \(plistName) ]"
    }
}
