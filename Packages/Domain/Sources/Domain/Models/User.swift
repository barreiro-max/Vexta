//
//  User.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public struct User: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let email: String
    public let username: String
    public let phone: String

    public init(
        id: Int,
        email: String,
        username: String,
        phone: String
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.phone = phone
    }
}
