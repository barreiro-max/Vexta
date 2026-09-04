//
//  FirebaseAuthStateObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 30.07.2026.
//

import Foundation
import FirebaseAuth
import Domain
import Telemetry

public struct FirebaseAuthStateObserver {
    public init() {}
    private var auth: Auth { Auth.auth() }
}

extension FirebaseAuthStateObserver: AuthStateObserver {

    public func fetchAuthState() -> AuthState {
        guard let userId = auth.currentUser?.uid else {
            Log.auth.debug("Auth state is unauthenticated")
            return .unauthenticated
        }
        Log.auth.debug("Auth state is authenticated with id: \(userId)")
        return .authenticated(userId: userId)
    }

    public var isAuthenticated: Bool {
        let authResult = auth.currentUser != nil
        Log.auth.debug("User is authenticated: [\(authResult)]")
        return authResult
    }

    public var streamUserIds: AsyncStream<String?> {
        AsyncStream { continuation in
            let task = Task {
                Log.auth.debug("Stream user ids started")
                await observeAuthState(with: continuation)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                Log.auth.debug("Stream user ids stopped")
                task.cancel()
            }
        }
    }

    private func observeAuthState(
        with continuation: AsyncStream<String?>.Continuation
    ) async {
        for await user in auth.authStateChanges {
            if Task.isCancelled { break }
            let uid = user?.uid
            Log.auth.debug("Stream user ids yields with: [\(String(describing: uid))]")
            continuation.yield(uid)
        }
    }
}
