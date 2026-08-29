//
//  AppleSignInResult.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation

public struct AppleSignInResult: Sendable {
    public init(
        idToken: String,
        fullName: PersonNameComponents?,
        nonce: String
    ) {
        self.idToken = idToken
        self.fullName = fullName
        self.nonce = nonce
    }

    public let idToken: String
    public let fullName: PersonNameComponents?
    public let nonce: String
}
