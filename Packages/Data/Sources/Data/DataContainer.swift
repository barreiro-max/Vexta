//
//  DataContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation
import SwiftData
import Domain

public final class DataContainer {
    public init() {}

    private let cacheTTL       = TimeInterval(600)
    private let persistenceTTL = TimeInterval(86400)

    lazy var productCache: any InMemoryCache<Product> = makeCache()
    lazy var cartCache: any InMemoryCache<Cart>       = makeCache()
    lazy var userCache: any InMemoryCache<User>       = makeCache()

    lazy var productPersistence: any LocalDataSource<ProductEntity> = makePersistence()
    lazy var cartPersistence: any LocalDataSource<CartEntity>       = makePersistence()
    lazy var userPersistence: any LocalDataSource<UserEntity>       = makePersistence()

    lazy var remoteDataSource = makeRemoteDataSource()

    lazy var productRepository = ProductRepositoryImpl(
        cache: productCache,
        persistence: productPersistence,
        remote: remoteDataSource,
    )

    lazy var cartRepository = CartRepositoryImpl(
        cache: cartCache,
        persistence: cartPersistence,
        remote: remoteDataSource,
    )

    lazy var userRepository = UserRepositoryImpl(
        cache: userCache,
        persistence: userPersistence,
        remote: remoteDataSource,
    )

    public lazy var networkMonitor = NWPathNetworkMonitor(monitor: .init())
    public lazy var authStateObserver = FirebaseAuthStateObserver()
}

// MARK: - DataFactory

protocol DataFactory {

    func makeCache<Domain>() -> any InMemoryCache<Domain>
    where Domain: Identifiable, Domain: Hashable

    func makePersistence<Entity>() -> any LocalDataSource<Entity>
    where Entity: PersistentModel, Entity: TTLValidatable, Entity: DomainConvertable

    func makeRemoteDataSource() -> any RemoteDataSource
}

extension DataContainer: DataFactory {

    func makeCache<Domain>() -> any InMemoryCache<Domain> where Domain: Identifiable, Domain: Hashable, Domain: Sendable, Domain.ID: Sendable {
        InMemoryTTLCache<Domain>(TTL: cacheTTL)
    }

    func makePersistence<Entity>() -> any LocalDataSource<Entity> where Entity: PersistentModel, Entity: TTLValidatable, Entity: DomainConvertable {
        SwiftDataSourceImpl<Entity>(
            modelContainer: makeModelContainer(for: Entity.self),
            TTL: persistenceTTL
        )
    }

    func makeRemoteDataSource() -> any RemoteDataSource {
        let client = AlamofireClient(
            session: .default
        )
        let dataSource = RemoteDataSourceImpl(client: client)
        return dataSource
    }

    private func makeModelContainer<Entity: Equatable & PersistentModel>(
        for type: Entity.Type
    ) -> ModelContainer {
        let schema = Schema([type])
        let configuration = ModelConfiguration(
            "ModelContainer_\(type)",
            schema: schema
        )

        do {
            let modelContainer = try ModelContainer(
                for: schema,
                configurations: configuration
            )
            return modelContainer
        } catch {
            fatalError("Failed to configure ModelContainer for type: \(type)")
        }
    }
}
