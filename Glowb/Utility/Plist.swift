//
//  Plist.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/9/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

struct Plist {
    struct Config: PlistReadable {
        static var plistName = "Configuration"
        static var appId = Config.unsafeString("APP_ID")
        static var APIRoot = Config.unsafeString("API_URL")
    }
}
