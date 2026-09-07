//
//  NotificationError.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

public enum NotificationError: Error, LocalizedError, Equatable {
    case failureAddedRequest
    case accessDenied
    case invalidTrigger
    case invalidContent

    public var errorDescription: String? {
        switch self {
        case .failureAddedRequest:
            String(localized: "Failed to schedule notification.")
        case .accessDenied:
            String(localized: "Notification permissions denied.")
        case .invalidTrigger:
            String(localized: "Invalid notification trigger.")
        case .invalidContent:
            String(localized: "Invalid notification content.")
        }
    }
}
