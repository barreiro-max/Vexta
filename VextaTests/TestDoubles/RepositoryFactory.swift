//
//  RepositoryFactory.swift
//  VextaTests
//
//  Created by MaxAdmin on 30.06.2026.
//

import Foundation
import SwiftData
@testable import Vexta

struct RepositoryFactory {
    private let cacheTTL: TimeInterval = 5
    private let persistenceTTL: TimeInterval = 10

    func makeProductRepository() -> ProductRepositoryImpl {
        let cache = InMemoryTTLCache<Product>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<ProductEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getProduct(withID: 1), ProductDTO.stubData),
            (.getProducts, ProductDTO.stubsData)
        ]
        let remote = makeRemote(responses: responses)

        return .init(cache: cache, persistence: persistence, remote: remote)
    }

    func makeCartRepository() -> CartRepositoryImpl {
        let cache = InMemoryTTLCache<Cart>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<CartEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getCart(withID: 1), CartDTO.stubData),
            (.getCarts, CartDTO.stubsData)
        ]
        let remote = makeRemote(responses: responses)

        return .init(cache: cache, persistence: persistence, remote: remote)
    }

    func makeUserRepository() -> UserRepositoryImpl {
        let cache = InMemoryTTLCache<User>(TTL: cacheTTL)
        let persistence: SwiftDataSourceImpl<UserEntity> = makePersistence(persistenceTTL: persistenceTTL)
        let responses = [
            (FakeStoreEndpoint.getUser(withID: 1), UserDTO.stubData)
        ]
        let remote = makeRemote(responses: responses)
        return .init(cache: cache, persistence: persistence, remote: remote)
    }

    private func makePersistence<T>(persistenceTTL: TimeInterval) -> SwiftDataSourceImpl<T> {
        do {
            let modelContainer = try ModelContainer(
                for: .init(T.self),
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )

            let persistence = SwiftDataSourceImpl<T>(
                modelContainer: modelContainer,
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
            )
        )
        let remote = RemoteDataSourceImpl(client: client)
        return remote
    }
}
