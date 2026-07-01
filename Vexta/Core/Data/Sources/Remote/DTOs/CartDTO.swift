//
//  CartDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation

struct CartDTO: Codable, Hashable, Equatable {
    let cartId: Int
    let userId: Int

    let createdAt: Date
    let items: [ItemDTO]

    enum CodingKeys: String, CodingKey {
        case cartId = "id"
        case userId
        case createdAt = "date"
        case items = "products"
    }

    struct ItemDTO: Codable, Hashable, Equatable {
        let productId: Int
        let quantity: Int
        
        var toDomain: Cart.Item {
            Cart.Item(
                productId: productId,
                quantity: quantity
            )
        }
        
        var toEntity: CartItemEntity {
            CartItemEntity(
                productId: productId,
                quantity: quantity
            )
        }
    }

    var toDomain: Cart {
        Cart(
            id: cartId,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toDomain)
        )
    }

    var toEntity: CartEntity {
        CartEntity(
            id: cartId,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toEntity)
        )
    }
}
