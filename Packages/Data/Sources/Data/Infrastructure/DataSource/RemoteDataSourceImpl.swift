//
//  RemoteDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation
import Domain

struct RemoteDataSourceImpl: Sendable {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }
}

extension RemoteDataSourceImpl: RemoteDataSource {
    func fetchProducts() async throws(RemoteError) -> [ProductDTO] {
        try await client.request(endpoint: FakeStoreEndpoint.getProducts)
    }

    func fetchCarts() async throws(RemoteError) -> [CartDTO] {
        try await client.request(endpoint: FakeStoreEndpoint.getCarts)
    }

    func fetchProduct(id: Int) async throws(RemoteError) -> ProductDTO {
        try await client.request(endpoint: FakeStoreEndpoint.getProduct(withID: id))
    }

    func fetchCart(id: Int) async throws(RemoteError) -> CartDTO {
        try await client.request(endpoint: FakeStoreEndpoint.getCart(withID: id))
    }

    func fetchUser(id: Int) async throws(RemoteError) -> UserDTO {
        try await client.request(endpoint: FakeStoreEndpoint.getUser(withID: id))
    }
}
