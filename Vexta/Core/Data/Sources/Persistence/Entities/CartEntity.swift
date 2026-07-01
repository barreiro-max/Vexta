//
//  ProductEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData

@Model
final class CartEntity: TTLValidatable, Sendable {
    @Attribute(.unique) var id: Int
    var userId: Int

    var createdAt: Date
    @Relationship(deleteRule: .cascade) var items: [CartItemEntity]

    init(
        id: Int,
        userId: Int,
        createdAt: Date = .now,
        items: [CartItemEntity] = []
    ) {
        self.id = id
        self.userId = userId
        self.items = items
        self.createdAt = createdAt
    }

    var toDomain: Cart {
        Cart(
            id: id,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toDomain)
        )
    }
}

extension CartEntity: Equatable {
    static func == (lhs: CartEntity, rhs: CartEntity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.userId == rhs.userId &&
               lhs.createdAt == rhs.createdAt &&
               lhs.items == rhs.items
    }
}
