//
//  NotificationError.swift
//  Vexta
//
//  Created by MaxAdmin on 02.09.2026.
//

import Foundation

public enum NotificationError: Error {
    case failureAddedRequest
    case accessDenied
    case invalidTrigger
    case invalidContent
}
