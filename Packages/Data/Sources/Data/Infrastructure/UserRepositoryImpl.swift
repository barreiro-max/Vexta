//
//  UserRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

actor UserRepositoryImpl: UserRepository {

    private let cache: any InMemoryCache<User>
    private let persistence: any LocalDataSource<UserEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<User>,
        persistence: any LocalDataSource<UserEntity>,
        remote: any RemoteDataSource,
    ) {
        self.cache = cache
        self.persistence = persistence
        self.remote = remote
    }

    func fetch(userId: Int) async throws(RepositoryError) -> User {
        if let cached = cache.get(for: userId) {
            return cached
        }

        do {
            if let stored = try await persistence.read(for: userId) {
                cache.set(stored)
                return stored
            }

            let fetched = try await remote.fetchUser(id: userId)

            let entity = fetched.toEntity
            try await persistence.write(entity.persistentModelID)

            let domain = fetched.toDomain
            cache.set(domain)
            return domain
        } catch {
            let repositoryError = RepositoryError(from: error)

            throw repositoryError
        }
    }
}
