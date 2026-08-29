//
//  CartDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import Domain

public struct CartDTO: Codable, Hashable, Equatable, Sendable {
    public let cartId: Int
    public let userId: Int

    public let createdAt: Date
    public let items: [ItemDTO]

    enum CodingKeys: String, CodingKey {
        case cartId = "id"
        case userId
        case createdAt = "date"
        case items = "products"
    }

    public struct ItemDTO: Codable, Hashable, Equatable, Sendable {
        public let productId: Int
        public let quantity: Int

        public var toDomain: Cart.Item {
            Cart.Item(
                productId: productId,
                quantity: quantity
            )
        }
        
        public var toEntity: CartItemEntity {
            CartItemEntity(
                productId: productId,
                quantity: quantity
            )
        }
    }

    public var toDomain: Cart {
        Cart(
            id: cartId,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toDomain)
        )
    }

    public var toEntity: CartEntity {
        CartEntity(
            id: cartId,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toEntity)
        )
    }
}
