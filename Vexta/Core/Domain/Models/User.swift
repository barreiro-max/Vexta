//
//  User.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct User: Identifiable, Equatable, Hashable {
    let id: Int
    let email: String
    let username: String
    let phone: String
}
