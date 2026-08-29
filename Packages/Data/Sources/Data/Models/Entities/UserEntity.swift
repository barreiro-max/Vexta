//
//  ProductEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData
import Domain

@Model
public final class UserEntity: TTLValidatable, DomainConvertable {
    @Attribute(.unique) public var id: Int
    public var email: String
    public var username: String
    public var phone: String
    public var createdAt: Date

    public init(
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

    public var toDomain: User {
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

