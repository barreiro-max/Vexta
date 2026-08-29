//
//  FirebaseAnalyticsService.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import Foundation
import FirebaseAnalytics
import Domain

public struct FirebaseAnalyticsTracker {
    public init() {}
}

extension FirebaseAnalyticsTracker: AnalyticsTracker {
    public func track(event: AnalyticsEvent) {
        matchAnalyticsEvent(for: event)
    }

    public func set(userId id: String) {
        Analytics.setUserID(id)
    }

    public func setUserProperty(event value: String?, name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}

extension FirebaseAnalyticsTracker {
    private func matchAnalyticsEvent(for event: AnalyticsEvent) {
        switch event {
        case .addUser(let value):
            logEvent(
                eventName: "AddUser",
                parameters: [AnalyticsParameterValue: value]
            )
        case .userLoggedIn:
            logEvent(eventName: "UserLoggedIn")
        case .userLoggedOut:
            logEvent(eventName: "UserLoggedOut")
        case .userRegistered:
            logEvent(eventName: "UserRegistered")
        }
    }

    private func logEvent(eventName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}
