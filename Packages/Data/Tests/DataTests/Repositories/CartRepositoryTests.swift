//
//  CartRepositoryTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 30.06.2026.
//

import Foundation
import Testing
@testable import Data

@Suite(.tags(.repository))
struct CartRepositoryTests {
    private let sut: CartRepositoryImpl
    private let TTL: TimeInterval

    init() {
        TTL = 5
        sut = RepositoryFactory().makeCartRepository()
    }

    @Test func repository_fetch_dataFlow_network_cache_invalidation_persistence() async throws {
        let remoteDTO = try await sut.fetch(cartId: 1)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decodedDomain = try decoder.decode(
            CartDTO.self,
            from: CartDTO.stubData
        ).toDomain

        #expect(remoteDTO == decodedDomain)

        let cachedDomain = try await sut.fetch(cartId: 1)
        #expect(cachedDomain == decodedDomain)
        try await Task.sleep(for: .seconds(TTL + 0.1))
        let persistentDomain = try await sut.fetch(cartId: 1)
        #expect(persistentDomain == decodedDomain)
    }

    @Test func repository_fetchAll_dataFlow_network_cache_invalidation_persistence() async throws {
        let remoteDTOs = try await sut.fetchAll()

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decodedDomains = try decoder.decode(
            [CartDTO].self,
            from: CartDTO.stubsData
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

