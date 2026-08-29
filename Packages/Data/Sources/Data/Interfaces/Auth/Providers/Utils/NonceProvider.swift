//
//  NonceProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol NonceProvider: Sendable {
    func randomNonceString(length: Int) -> String
    func sha256(_ input: String) -> String
}
