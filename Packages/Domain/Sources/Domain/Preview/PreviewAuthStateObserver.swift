//
//  PreviewAuthStateObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 10.08.2026.
//

import Foundation

public struct PreviewAuthStateObserver: AuthStateObserver {
    public let isAuthenticated: Bool

    public init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
    
    public func fetchAuthState() -> AuthState {
        if isAuthenticated {
            .authenticated(userId: "preview_user_uid")
        } else {
            .unauthenticated
        }
    }

    public var stream: AsyncStream<AuthState> = .init { continuation in
        continuation.yield(.authenticated(userId: "preview_user_uid_2"))
        continuation.yield(.authenticated(userId: "preview_user_uid_3"))
        continuation.yield(.authenticated(userId: "preview_user_uid_4"))
        continuation.finish()
    }
}
