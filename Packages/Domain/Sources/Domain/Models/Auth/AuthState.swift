//
//  AuthState.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public enum AuthState: Equatable, Sendable {
    case neededEmailVerification(userId: String)
    case authenticated(userId: String)
    case unauthenticated
}
