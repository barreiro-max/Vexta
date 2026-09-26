//
//  RemoteConfigValueMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 18.09.2026.
//

import Foundation
import Domain
import FirebaseRemoteConfig

extension Domain.RemoteConfigValue {

    public init(key: String, firValue: FirebaseRemoteConfig.RemoteConfigValue) {
        if let json = firValue.jsonValue {
            self = .jsonValue(for: key, json: json)
            return
        }

        let string = firValue.stringValue
        if string.lowercased() == "true" || string.lowercased() == "false" {
            self = .boolValue(for: key, value: firValue.boolValue)
            return
        }

        if let doubleValue = Double(string) {
            self = .doubleValue(for: key, number: doubleValue)
            return
        }

        self = .stringValue(for: key, value: string)
    }
}

