//
//  PersistenseTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 25.06.2026.
//

import Foundation
import Testing
import SwiftData
@testable import Data

@Suite(.tags(.datasource))
struct PersistenceTests {

    private let sut: SwiftDataSourceImpl<ProductEntity>
    private let TTL: TimeInterval

    init() async throws {
        let modelContainer = try ModelContainer.makeInMemoryContainer(
            for: ProductEntity.self
        )
        let errorMapper = PersistenceErrorMapper()

        TTL = 1
        sut = SwiftDataSourceImpl(
            modelContainer: modelContainer,
            errorMapper: errorMapper,
            TTL: TTL
        )
    }

    @Test func write_readedEqualStub() async throws {
        let stub = ProductEntity.stub

        try await sut.write(stub.persistentModelID)

        let readed = try #require(
            try await sut.read(for: stub.id)
        )
        #expect(readed == stub.toDomain)
    }

    @Test func writeAll_readedEqualStubs() async throws {
        let stubs = ProductEntity.stubs

        try await sut.writeAll(stubs.map(\.persistentModelID))

        let readed = try #require(
            try await sut.readAll()
        )
        #expect(readed == stubs.map(\.toDomain))
    }

    @Test func remove_stubEqualNil() async throws {
        let stub = ProductEntity.stub
        try await sut.write(stub.persistentModelID)

        try await sut.remove(stub.persistentModelID)

        let deleted = try await sut.read(for: stub.id)
        #expect(deleted == nil)
    }

    @Test func read_readedEqualStub() async throws {
        let stub = ProductEntity.stub
        try await sut.write(stub.persistentModelID)

        let readed = try #require(
            try await sut.read(for: stub.id)
        )

        #expect(readed == stub.toDomain)
    }

    @Test func read_afterExpiredTTL_shoulEqualNil() async throws {
        let stub = ProductEntity.stub
        try await sut.write(stub.persistentModelID)

        try await Task.sleep(for: .seconds(TTL + 0.1))
        let readed = try await sut.read(for: stub.id)

        #expect(readed == nil)
    }

    @Test func readAll_readedEqualStubs() async throws {
        let stubs = ProductEntity.stubs
        for stub in stubs {
            try await sut.write(stub.persistentModelID)
        }

        let readed = try await sut.readAll()

        #expect(readed == stubs.map(\.toDomain))
    }

    @Test func readAll_afterClear_shoulEqualNil() async throws {
        let stubs = ProductEntity.stubs
        for stub in stubs {
            try await sut.write(stub.persistentModelID)
            try await sut.remove(stub.persistentModelID)
        }

        let cleared = try await sut.readAll()

        #expect(cleared == nil)
    }

    @Test func readAll_afterExpiredTTL_shoulEqualNil() async throws {
        let stubs = ProductEntity.stubs
        for stub in stubs {
            try await sut.write(stub.persistentModelID)
        }

        try await Task.sleep(for: .seconds(TTL + 0.1))
        let readed = try await sut.readAll()

        #expect(readed == nil)
    }

    @Test func invalidate_afterExpiredTTL_shouldClear() async throws {
        let stubs = ProductEntity.stubs
        for stub in stubs {
            try await sut.write(stub.persistentModelID)
        }

        try await Task.sleep(for: .seconds(TTL + 0.1))
        try await sut.invalidate()

        await #expect(throws: Never.self) {
            try await sut.isEmpty
        }
    }
}
