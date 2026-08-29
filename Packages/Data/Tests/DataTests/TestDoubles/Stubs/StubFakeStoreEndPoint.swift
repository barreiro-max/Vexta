//
//  FakeStoreEndPoint+AllCases.swift
//  VextaTests
//
//  Created by MaxAdmin on 26.06.2026.
//

@testable import Data

extension FakeStoreEndpoint {

    static var stubs: [(FakeStoreEndpoint, String)] {
        [
            (.getProduct(withID: 1), "/products/1"),
            (.getCart(withID: 1), "/carts/1"),
            (.getUser(withID: 1), "/users/1")
        ]
    }
}
