//
//  RemoteConfigKey.swift
//  Vexta
//
//  Created by MaxAdmin on 08.07.2026.
//

import Foundation

public enum RemoteConfigKey: String {
    case isForceUpdate = "is_force_update"

    public var toString: String { rawValue }
}
