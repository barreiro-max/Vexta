//
//  UserRepositoryTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 30.06.2026.
//

import Foundation
import Testing
@testable import Data

@Suite(.tags(.repository))
struct UserRepositoryTests {
    private let sut: UserRepositoryImpl
    private let TTL: TimeInterval

    init() {
        TTL = 5
        sut = RepositoryFactory().makeUserRepository()
    }

    @Test
    func repository_fetch_dataFlow_network_cache_invalidation_persistence() async throws {
        let remoteDTO = try await sut.fetch(userId: 1)

        let decodedDomain = try JSONDecoder().decode(
            UserDTO.self,
            from: UserDTO.stubData
        ).toDomain

        #expect(remoteDTO == decodedDomain)

        let cachedDomain = try await sut.fetch(userId: 1)
        #expect(cachedDomain == decodedDomain)
        try await Task.sleep(for: .seconds(TTL + 0.1))
        let persistentDomain = try await sut.fetch(userId: 1)
        #expect(persistentDomain == decodedDomain)
    }
}
