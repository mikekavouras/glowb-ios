//
//  Int+Date.swift
//  Glowb
//
//  Created by Michael Kavouras on 12/20/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

import Foundation

extension Int {
    var day: Int { return 60 * 60 * 24 * self }
    var days: Int { return day }
    var week: Int { return day * 7 }
    var weeks: Int { return week }
    
    var fromNow: Date {
        return Date(timeInterval: TimeInterval(self), since: Date())
    }
}
