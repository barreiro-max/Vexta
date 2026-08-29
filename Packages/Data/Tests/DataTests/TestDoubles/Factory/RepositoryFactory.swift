//
//  RepositoryFactory.swift
//  VextaTests
//
//  Created by MaxAdmin on 30.06.2026.
//

import Foundation
import SwiftData
@testable import Data
@testable import Domain

struct RepositoryFactory {
    private let cacheTTL: TimeInterval = 5
    private let persistenceTTL: TimeInterval = 10

    private let persistenceErrorMapper = PersistenceErrorMapper()
    private let remoteErrorMapper = RemoteErrorMapper()
    private let repositoryErrorMapper = RepositoryErrorMapper()

    func makeProductRepository() -> ProductRepositoryImpl {
        let cache = InMemoryTTLCache<Product>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<ProductEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getProduct(withID: 1), ProductDTO.stubData),
            (.getProducts, ProductDTO.stubsData)
        ]
        let remote = makeRemote(responses: responses)

        return .init(cache: cache, persistence: persistence, remote: remote, errorMapper: repositoryErrorMapper)
    }

    func makeCartRepository() -> CartRepositoryImpl {
        let cache = InMemoryTTLCache<Cart>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<CartEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getCart(withID: 1), CartDTO.stubData),
            (.getCarts, CartDTO.stubsData)
        ]
        let remote = makeRemote(responses: responses)

        return .init(cache: cache, persistence: persistence, remote: remote, errorMapper: repositoryErrorMapper)
    }

    func makeUserRepository() -> UserRepositoryImpl {
        let cache = InMemoryTTLCache<User>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<UserEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getUser(withID: 1), UserDTO.stubData)
        ]
        let remote = makeRemote(responses: responses)
        return .init(cache: cache, persistence: persistence, remote: remote, errorMapper: repositoryErrorMapper)
    }

    private func makePersistence<T>(persistenceTTL: TimeInterval) -> SwiftDataSourceImpl<T> {
        do {
            let modelContainer = try ModelContainer(
                for: Schema([T.self]),
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )

            let persistence = SwiftDataSourceImpl<T>(
                modelContainer: modelContainer, errorMapper: persistenceErrorMapper,
                TTL: persistenceTTL
            )
            return persistence
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }

    private func makeRemote(
        responses: [
            (FakeStoreEndpoint, Data)
        ]
    ) -> RemoteDataSourceImpl {
        let client = AlamofireClient(
            session: SessionFactory().makeMockSession(
                responses: responses
            ), errorMapper: remoteErrorMapper
        )
        let remote = RemoteDataSourceImpl(client: client)
        return remote
    }
}
