//
//  RemoteConfigValue.swift
//  Vexta
//
//  Created by MaxAdmin on 17.09.2026.
//

import Foundation

public enum RemoteConfigValue {
    case stringValue(for: String, value: String)
    case boolValue(for: String, value: Bool)
    case doubleValue(for: String, number: Double)
    case jsonValue(for: String, json: Any)
}


