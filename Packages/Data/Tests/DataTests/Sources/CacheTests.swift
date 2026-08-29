//
//  VextaTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 25.06.2026.
//

import Foundation
import Testing
@testable import Data
@testable import Domain

@Suite(.tags(.datasource))
struct CacheTests {
    private let sut: InMemoryTTLCache<Product>
    private let TTL: TimeInterval

    init() {
        self.TTL = 1
        self.sut = InMemoryTTLCache(TTL: TTL)

        for stub in Product.stubs {
            sut.set(stub)
        }
    }

    @Test func get_invalid_equalNil() async throws {
        try await Task.sleep(for: .seconds(TTL + 0.1))
        let invalid = sut.get(for: Product.stub.id)

        #expect(invalid == nil)

        let cached = sut.get(for: Product.stub.id)

        #expect(
            cached == nil,
            "The stub must be cleared from the cache after its TTL expires"
        )
    }

    @Test func get_valid_equalStub() async throws {
        let expectedId = Product.stubs[0].id
        let cached = try #require(
            sut.get(for: expectedId)
        )
        #expect(cached.id == expectedId)
    }

    @Test func getAll_invalid_equalNil() async throws {
        try await Task.sleep(for: .seconds(TTL + 0.1))

        let invalid = sut.getAll()
        
        #expect(invalid == nil)

        let cached = sut.getAll()

        #expect(
            cached == nil,
            "The stubs must be cleared from the cache after its TTL expires"
        )
    }

    @Test func getAll_valid_equalStubs_inAnyOrder() async throws {
        let cached = try #require(
            sut.getAll()
        )

        #expect(
            Set(cached) == Set(Product.stubs)
        )
    }

    @Test func set_writesStub() async throws {
        let stub = Product.stub
        sut.set(stub)

        let cached = try #require(
            sut.get(for: stub.id)
        )
        #expect(cached == stub)
    }

    @Test func set_updatesExistingStub() async throws {
        let stub = Product.stubs[0]
        let updatedStub = Product.stubs[1]
        sut.set(stub)
        let cached = try #require(
            sut.get(for: stub.id)
        )
        #expect(cached == stub)

        sut.set(updatedStub)

        let updatedCache = try #require(
            sut.get(for: updatedStub.id)
        )
        #expect(updatedCache == updatedStub)
    }

    @Test func setAll_writeStubs_returnAllValidStubs() async throws {
        try await Task.sleep(for: .seconds(TTL + 0.1)) // invalidate initial stubs

        let stubs = Product.stubs
        sut.setAll(stubs)

        let cached = try #require(
            sut.getAll()
        )

        #expect(
            Set(cached) == Set(stubs)
        )
    }

    @Test func setAll_updateExistingStubs() async throws {
        let stubs = Product.stubs
        let updatedStubs = Product.stubs
        sut.setAll(stubs)
        let cached = try #require(
            sut.getAll()
        )
        #expect(
            Set(cached) == Set(stubs)
        )

        sut.setAll(updatedStubs)

        let updatedCache = try #require(
            sut.getAll()
        )

        #expect(
            Set(updatedCache) == Set(updatedStubs)
        )
    }

    @Test func remove_success() async throws {
        sut.remove(for: Product.stub.id)

        let removed = sut.get(for: Product.stub.id)
        #expect(removed == nil)
    }

    @Test func remove_shouldClearCache() async throws {
        for stub in Product.stubs {
            sut.remove(for: stub.id)
        }

        #expect(sut.isEmpty)
    }
}
