//
//  SplashStoreEvent.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

public enum SplashStoreEvent {
    case authenticated(userId: String)
    case unauthenticated
    case alerted(error: SplashError, onRetry: @MainActor () async -> Void)
}
