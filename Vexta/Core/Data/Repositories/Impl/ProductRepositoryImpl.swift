//
//  ProductRepositoryImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

final class ProductRepositoryImpl: ProductRepository {

    private let cache: any InMemoryCache<Product>
    private let persistence: any LocalDataSource<ProductEntity>
    private let remote: any RemoteDataSource

    init(
        cache: any InMemoryCache<Product>,
        persistence: any LocalDataSource<ProductEntity>,
        remote: any RemoteDataSource
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
                let domains = stored.map(\.toDomain)
                cache.setAll(domains)

                return domains
            }
            let fetched = try await remote.fetchProducts()

            let entities = fetched.map(\.toEntity)
            try await persistence.writeAll(entities)

            let domains = fetched.map(\.toDomain)
            cache.setAll(domains)

            return domains

        } catch {
            throw RepositoryError(from: error)
        }
    }

    func fetch(productId: Int) async throws(RepositoryError) -> Product {
        if let cached = cache.get(for: productId) {
            return cached
        }

        do {
            if let stored = try await persistence.read(for: productId) {
                let domain = stored.toDomain
                cache.set(domain)
                return domain
            }

            let fetched = try await remote.fetchProduct(id: productId)
            
            try await persistence.write(fetched.toEntity)

            let domain = fetched.toDomain
            cache.set(domain)
            return domain
        } catch {
            throw RepositoryError(from: error)
        }
    }
}
