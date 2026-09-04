//
//  UNAuthorizationStatus+ToString.swift
//  Vexta
//
//  Created by MaxAdmin on 18.07.2026.
//

import Foundation
import UserNotifications

extension UNAuthorizationStatus {

    public var toString: String {
        switch self {
        case .authorized:    "Authorized"
        case .denied:        "Denied"
        case .notDetermined: "Not Determined"
        case .provisional:   "Provisional"
        case .ephemeral:     "Ephemeral"
        @unknown default:    "Unknown"
        }
    }
}
