//
//  AuthState.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public enum AuthState: Sendable {
    case authenticated(userId: String)
    case unauthenticated
}
