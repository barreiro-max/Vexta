//
//  FakeStoreEndpoint.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

enum FakeStoreEndpoint: Endpoint, Equatable {
    
    case getProducts
    case getCarts

    case getProduct(withID: Int)
    case getCart(withID: Int)
    case getUser(withID: Int)

    var path: String {
        switch self {

        case .getProducts:
            "/products"

        case .getCarts:
            "/carts"

        case .getProduct(let id):
            "/products/\(id)"

        case .getCart(let id):
            "/carts/\(id)"

        case .getUser(let id):
            "/users/\(id)"
        }
    }
}


