//
//  RemoteConfigKey.swift
//  Vexta
//
//  Created by MaxAdmin on 08.07.2026.
//

import Foundation

public enum RemoteConfigKey: String {
    case maintenanceMessage = "maintenance_message"
    case forceUpdateURL = "force_update_url"

    public var toString: String { rawValue }
}
