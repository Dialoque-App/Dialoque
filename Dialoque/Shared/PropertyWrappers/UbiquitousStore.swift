//
//  UbiquitousStore.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-14.
//

import Foundation

@propertyWrapper
struct UbiquitousTimeInterval {
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: TimeInterval {
        get {
            return NSUbiquitousKeyValueStore.default.double(forKey: key)
        }
        set {
            NSUbiquitousKeyValueStore.default.set(newValue, forKey: key)
            NSUbiquitousKeyValueStore.default.synchronize()
        }
    }
}

extension NSUbiquitousKeyValueStore {
    @UbiquitousTimeInterval(key: "streakStart")
    static var ubiquitousStreakStart: TimeInterval
    @UbiquitousTimeInterval(key: "streakDeadline")
    static var ubiquitousStreakDeadline: TimeInterval
}
