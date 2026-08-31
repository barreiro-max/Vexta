//
//  AnalyticsEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 03.07.2026.
//

import Foundation

public enum AnalyticsEvent: Sendable {
    case addUser(value: String)
    case userLoggedIn
    case userLoggedOut

    case userRegistered
    case emailVerificationSent
    case emailVerificationCompleted
}
