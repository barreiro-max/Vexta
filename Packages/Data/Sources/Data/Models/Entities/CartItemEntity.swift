//
//  ItemEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 25.06.2026.
//

import Foundation
import SwiftData
import Domain

@Model
public final class CartItemEntity: DomainConvertable {
    public var productId: Int
    public var quantity: Int

    public init(
        productId: Int,
        quantity: Int
    ) {
        self.productId = productId
        self.quantity = quantity
    }

    public var toDomain: Cart.Item {
        Cart.Item(
            productId: productId,
            quantity: quantity
        )
    }
}

extension CartItemEntity: Equatable {
    public static func == (lhs: CartItemEntity, rhs: CartItemEntity) -> Bool {
        return lhs.productId == rhs.productId &&
               lhs.quantity == rhs.quantity
    }
}
