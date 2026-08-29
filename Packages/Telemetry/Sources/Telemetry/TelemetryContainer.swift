//
//  TelemetryContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import Foundation

public final class TelemetryContainer {
    public init() {}

    public lazy var analyticsTracker    = FirebaseAnalyticsTracker()
    public lazy var crashlyticsRecorder = FirebaseCrashlyticsRecorder()
    public lazy var telemetryService    = FirebasePrivacyMonitor(defaults: .standard)
}


