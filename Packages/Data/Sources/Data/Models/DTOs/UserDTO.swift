//
//  UserDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import Domain

public struct UserDTO: Codable, Equatable, Sendable {
    public let id: Int
    public let email: String
    public let username: String
    public let phone: String

    public var toDomain: User {
        User(
            id: id,
            email: email,
            username: username,
            phone: phone
        )
    }

    public var toEntity: UserEntity {
        UserEntity(
            id: id,
            email: email,
            username: username,
            phone: phone
        )
    }
}
