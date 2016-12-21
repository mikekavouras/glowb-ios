//
//  RubyDateTransform.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import ObjectMapper

struct RubyDateTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let date = value as? String else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        return formatter.date(from: date)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let date = value else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.string(from: date as Date)
    }
}
