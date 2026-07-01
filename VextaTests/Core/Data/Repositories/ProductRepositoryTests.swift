//
//  ProductRepositoryTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation
import Testing
@testable import Vexta

@Suite(.tags(.repository))
struct ProductRepositoryTests {
    private let sut: ProductRepositoryImpl
    private let TTL: TimeInterval

    init() {
        TTL = 5
        sut = RepositoryFactory().makeProductRepository()
    }

    @Test func repository_fetch_dataFlow_network_cache_invalidation_persistence() async throws {
        let remoteDTO = try await sut.fetch(productId: 1)

        let decodedDomain = try JSONDecoder().decode(
            ProductDTO.self,
            from: ProductDTO.stubData
        ).toDomain

        #expect(remoteDTO == decodedDomain)

        let cachedDomain = try await sut.fetch(productId: 1)
        #expect(cachedDomain == decodedDomain)
        try await Task.sleep(for: .seconds(TTL + 0.1))
        let persistentDomain = try await sut.fetch(productId: 1)
        #expect(persistentDomain == decodedDomain)
    }

    @Test func repository_fetchAll_dataFlow_network_cache_invalidation_persistence() async throws {
        let remoteDTOs = try await sut.fetchAll()

        let decodedDomains = try JSONDecoder().decode(
            [ProductDTO].self,
            from: ProductDTO.stubsData
        ).map(\.toDomain)

        #expect(remoteDTOs == decodedDomains)

        let cachedDomains = try await sut.fetchAll()
        #expect(
            Set(cachedDomains) == Set(decodedDomains)
        )
        try await Task.sleep(for: .seconds(TTL + 0.1))
        let persistentDomains = try await sut.fetchAll()
        #expect(
            Set(persistentDomains) == Set(decodedDomains)
        )
    }
}
