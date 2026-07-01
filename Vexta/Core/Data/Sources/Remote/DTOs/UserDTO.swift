//
//  UserDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation

struct UserDTO: Codable, Equatable {
    let id: Int
    let email: String
    let username: String
    let phone: String

    var toDomain: User {
        User(
            id: id,
            email: email,
            username: username,
            phone: phone
        )
    }

    var toEntity: UserEntity {
        UserEntity(
            id: id,
            email: email,
            username: username,
            phone: phone
        )
    }
}
