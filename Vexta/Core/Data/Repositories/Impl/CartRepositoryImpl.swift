//
//  CartRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

final class CartRepositoryImpl: CartRepository {

    private let cache: any InMemoryCache<Cart>
    private let persistence: any LocalDataSource<CartEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<Cart>,
        persistence: any LocalDataSource<CartEntity>,
        remote: any RemoteDataSource
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
                let domains = stored.map(\.toDomain)
                cache.setAll(domains)
                return domains
            }
            let fetched = try await remote.fetchCarts()

            let entities = fetched.map(\.toEntity)
            try await persistence.writeAll(entities)

            let domains = fetched.map(\.toDomain)
            cache.setAll(domains)
            return domains

        } catch {
            throw RepositoryError(from: error)
        }
    }

    func fetch(cartId: Int) async throws(RepositoryError) -> Cart {
        if let cached = cache.get(for: cartId) {
            return cached
        }

        do {
            if let stored = try await persistence.read(for: cartId) {
                let domain = stored.toDomain
                cache.set(domain)
                return domain
            }

            let fetched = try await remote.fetchCart(id: cartId)

            try await persistence.write(fetched.toEntity)
            
            let domain = fetched.toDomain
            cache.set(domain)
            return domain
        } catch {
            throw RepositoryError(from: error)
        }
    }
}
