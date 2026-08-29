//
//  AnalyticsTracker.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol AnalyticsTracker: Sendable {
    func track(event: AnalyticsEvent)
    func set(userId id: String)
    func setUserProperty(event value: String?, name: String)
}
