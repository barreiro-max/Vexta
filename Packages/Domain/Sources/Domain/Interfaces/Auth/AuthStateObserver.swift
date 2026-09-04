//
//  AuthStateObserver.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol AuthStateObserver: Sendable {
    func fetchAuthState() -> AuthState
    var isAuthenticated: Bool { get }
    var streamUserIds: AsyncStream<String?> { get }
}
