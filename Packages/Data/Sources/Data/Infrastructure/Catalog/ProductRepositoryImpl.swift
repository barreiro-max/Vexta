//
//  ProductRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

actor ProductRepositoryImpl: ProductRepository {

    private let cache: any InMemoryCache<Product>
    private let persistence: any LocalDataSource<ProductEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<Product>,
        persistence: any LocalDataSource<ProductEntity>,
        remote: any RemoteDataSource,
    ) {
        self.cache = cache
        self.persistence = persistence
        self.remote = remote
    }

    func fetchAll() async throws(RepositoryError) -> [Product] {
        if let cached = cache.getAll() {
            return cached
        }

        do {
            if let stored = try await persistence.readAll() {
                cache.setAll(stored)
                return stored
            }
            let fetched = try await remote.fetchProducts()

            let entities = fetched
                .map(\.toEntity.persistentModelID)

            try await persistence.writeAll(entities)

            let domains = fetched.map(\.toDomain)
            cache.setAll(domains)

            return domains

        } catch {
            let repositoryError = RepositoryError(from: error)

            throw repositoryError
        }
    }

    func fetch(productId: Int) async throws(RepositoryError) -> Product {
        if let cached = cache.get(for: productId) {
            return cached
        }

        do {
            if let stored = try await persistence.read(for: productId) {
                cache.set(stored)
                return stored
            }

            let fetched = try await remote.fetchProduct(id: productId)

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
