//
//  UserDefaultsFactory.swift
//  VextaTests
//
//  Created by MaxAdmin on 04.07.2026.
//

import Foundation

struct UserDefaultsFactory {
    func makeUserDefaults(suiteName: String) -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        return defaults
    }
}
