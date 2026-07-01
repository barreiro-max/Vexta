//
//  UserRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

final class UserRepositoryImpl: UserRepository {

    private let cache: any InMemoryCache<User>
    private let persistence: any LocalDataSource<UserEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<User>,
        persistence: any LocalDataSource<UserEntity>,
        remote: any RemoteDataSource
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
                let domain = stored.toDomain
                cache.set(domain)
                return domain
            }

            let fetched = try await remote.fetchUser(id: userId)

            try await persistence.write(fetched.toEntity)

            let domain = fetched.toDomain
            cache.set(domain)
            return domain
        } catch {
            throw RepositoryError(from: error)
        }
    }
}
