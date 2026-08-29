//
//  ProductEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData
import Domain

@Model
public final class CartEntity: TTLValidatable, DomainConvertable {
    @Attribute(.unique) public var id: Int
    public var userId: Int

    public var createdAt: Date
    @Relationship(deleteRule: .cascade) public var items: [CartItemEntity]

    public init(
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

    public var toDomain: Cart {
        Cart(
            id: id,
            userId: userId,
            createdAt: createdAt,
            items: items.map(\.toDomain)
        )
    }
}

extension CartEntity: Equatable {
    public static func == (lhs: CartEntity, rhs: CartEntity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.userId == rhs.userId &&
               lhs.createdAt == rhs.createdAt &&
               lhs.items == rhs.items
    }
}
