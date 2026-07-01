//
//  AFEndPoint.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Alamofire

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
        case let .getProduct(withID: id):
            "/products/\(id)"
        case let .getCart(withID: id):
            "/carts/\(id)"
        case let .getUser(withID: id):
            "/users/\(id)"
        }
    }
}


