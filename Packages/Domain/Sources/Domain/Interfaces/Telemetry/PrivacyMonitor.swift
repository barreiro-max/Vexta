//
//  PrivacyMonitor 2.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol PrivacyMonitor {
    var isTelemetryEnabled: Bool { get }
    func telemetryCollection(isEnabled: Bool)
    var needsGDPRConsent: Bool { get }
}
