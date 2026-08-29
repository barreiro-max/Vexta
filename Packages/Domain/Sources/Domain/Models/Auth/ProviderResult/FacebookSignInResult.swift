//
//  FacebookSignInResult {.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation

public struct FacebookSignInResult: Sendable {
    public init(accessToken: String) {
        self.accessToken = accessToken
    }

    public let accessToken: String
}
