//
//  GoogleSignInResult.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation

public struct GoogleSignInResult: Sendable {
    public init(idToken: String, accessToken: String) {
        self.idToken = idToken
        self.accessToken = accessToken
    }
    public let idToken: String
    public let accessToken: String
}
