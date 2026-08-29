//
//  FirebasePrivacyMonitor.swift
//  Vexta
//
//  Created by MaxAdmin on 04.07.2026.
//

import Foundation
import FirebaseCrashlytics
import FirebaseAnalytics
import Domain
import Environment

public struct FirebasePrivacyMonitor {

    private let privacyTelemetryKey: String = "isTelemetryCollectionEnabled"

    private let defaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

extension FirebasePrivacyMonitor: PrivacyMonitor {
    public var isTelemetryEnabled: Bool {
        defaults.bool(forKey: privacyTelemetryKey) &&
        Crashlytics.crashlytics().isCrashlyticsCollectionEnabled() &&
        InfoPlistConfiguration.isAnalyticsCollectionEnabled
    }

    public func telemetryCollection(isEnabled: Bool) {
        defaults.set(isEnabled, forKey: privacyTelemetryKey)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isEnabled)
        Analytics.setAnalyticsCollectionEnabled(isEnabled)
    }

    public var needsGDPRConsent: Bool {
        defaults.object(forKey: privacyTelemetryKey) == nil
    }
}
