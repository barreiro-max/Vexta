//
//  UserRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol UserRepository {
    func fetch(userId: Int) async throws(RepositoryError) -> User
}
