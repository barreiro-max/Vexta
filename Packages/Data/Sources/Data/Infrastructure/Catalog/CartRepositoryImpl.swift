//
//  CartRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

final class CartRepositoryImpl: CartRepository {

    private let cache: any InMemoryCache<Cart>
    private let persistence: any LocalDataSource<CartEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<Cart>,
        persistence: any LocalDataSource<CartEntity>,
        remote: any RemoteDataSource,
    ) {
        self.cache = cache
        self.persistence = persistence
        self.remote = remote
    }

    func fetchAll() async throws(RepositoryError) -> [Cart] {
        if let cached = cache.getAll() {
            return cached
        }

        do {
            if let stored = try await persistence.readAll() {
                cache.setAll(stored)
                return stored
            }
            let fetched = try await remote.fetchCarts()

            let entitiesIds = fetched
                .map(\.toEntity.persistentModelID)

            try await persistence.writeAll(entitiesIds)

            let domains = fetched.map(\.toDomain)
            cache.setAll(domains)
            return domains

        } catch {
            let repositoryError = RepositoryError(from: error)

            throw repositoryError
        }
    }

    func fetch(cartId: Int) async throws(RepositoryError) -> Cart {
        if let cached = cache.get(for: cartId) {
            return cached
        }

        do {
            if let stored = try await persistence.read(for: cartId) {
                cache.set(stored)
                return stored
            }

            let fetched = try await remote.fetchCart(id: cartId)

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
