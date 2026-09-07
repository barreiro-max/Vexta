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
        guard let user = auth.currentUser else {
            Log.auth.debug("Auth state is unauthenticated")
            return .unauthenticated
        }

        guard user.isEmailVerified || user.isAnonymous else {
            Log.auth.debug("Auth state is not verificated with id: \(user.uid)")
            return .neededEmailVerification(userId: user.uid)
        }

        Log.auth.debug("Auth state is authenticated with id: \(user.uid)")
        return .authenticated(userId: user.uid)
    }

    public var isAuthenticated: Bool {
        guard let user = auth.currentUser else {
            Log.auth.debug("User is unauthenticated")
            return false
        }
        Log.auth.debug("User is authenticated with id: [\(user.uid)]")
        return user.isEmailVerified || user.isAnonymous
    }

    public var stream: AsyncStream<AuthState> {
        AsyncStream { continuation in
            let task = Task {
                Log.auth.debug("Stream auth state started")
                await observeAuthState(with: continuation)
                continuation.finish()
                Log.auth.debug("Stream auth state finished")
            }
            continuation.onTermination = { _ in
                task.cancel()
                Log.auth.debug("Stream auth state stopped")
            }
        }
    }

    private func observeAuthState(
        with continuation: AsyncStream<AuthState>.Continuation
    ) async {
        var previous: AuthState?

        for await user in auth.authStateChanges {
            if Task.isCancelled { break }

            let currentState: AuthState? = await {
                guard let user else {
                    return .unauthenticated
                }

                guard user.isEmailVerified || user.isAnonymous else {
                    return .neededEmailVerification(userId: user.uid)
                }

                do {
                    try await user.getIDToken(forcingRefresh: true)
                    return .authenticated(userId: user.uid)
                } catch {
                    try? auth.signOut()
                    Log.auth.error("Token refresh failed, sign out from account...: \(error)")
                    return nil
                }
            }()

            guard let currentState else {
                Log.auth.debug("Current auth state is nil")
                continue
            }

            guard currentState != previous else {
                Log.auth.debug("Current auth state is equal previous")
                continue
            }
            previous = currentState

            continuation.yield(currentState)
            Log.auth.debug("Stream auth state yields with: \(currentState)")
        }
    }
}
