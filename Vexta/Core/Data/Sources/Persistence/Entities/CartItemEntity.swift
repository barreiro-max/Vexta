//
//  ItemEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 25.06.2026.
//

import Foundation
import SwiftData

@Model
final class CartItemEntity: Sendable {
    var productId: Int
    var quantity: Int

    init(
        productId: Int,
        quantity: Int
    ) {
        self.productId = productId
        self.quantity = quantity
    }

    var toDomain: Cart.Item {
        Cart.Item(
            productId: productId,
            quantity: quantity
        )
    }
}

extension CartItemEntity: Equatable {
    static func == (lhs: CartItemEntity, rhs: CartItemEntity) -> Bool {
        return lhs.productId == rhs.productId &&
               lhs.quantity == rhs.quantity
    }
}
