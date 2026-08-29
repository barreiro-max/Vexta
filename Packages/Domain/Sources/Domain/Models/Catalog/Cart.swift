//
//  CartItem.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public struct Cart: Identifiable, Hashable, Equatable, Sendable {
    public let id: Int
    public let userId: Int

    public let createdAt: Date
    public let items: [Item]

    public init(
        id: Int,
        userId: Int,
        createdAt: Date,
        items: [Item]
    ) {
        self.id = id
        self.userId = userId
        self.createdAt = createdAt
        self.items = items
    }

    public struct Item: Hashable, Equatable, Sendable {
        public let productId: Int
        public let quantity: Int

        public init(productId: Int, quantity: Int) {
            self.productId = productId
            self.quantity = quantity
        }
    }
}
