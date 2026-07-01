//
//  ProductEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData

@Model
final class UserEntity: TTLValidatable, Sendable {
    @Attribute(.unique) var id: Int
    var email: String
    var username: String
    var phone: String
    var createdAt: Date

    init(
        id: Int,
        email: String,
        username: String,
        phone: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.phone = phone
        self.createdAt = createdAt
    }

    var toDomain: User {
        User(
            id: id,
            email: email,
            username: username,
            phone: phone
        )
    }
}

extension UserEntity: Equatable {
    public static func == (lhs: UserEntity, rhs: UserEntity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.email == rhs.email &&
               lhs.username == rhs.username &&
               lhs.phone == rhs.phone &&
               lhs.createdAt == rhs.createdAt
    }
}

