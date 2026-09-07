//
//  FacebookSignInResult {.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation

public struct FacebookSignInResult: Sendable {
    public let authToken: String
    public let nonce: String

    public init(
        authToken: String,
        nonce: String,
    ) {
        self.authToken = authToken
        self.nonce = nonce
    }
}
