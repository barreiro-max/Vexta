//
//  CartItem.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct Cart: Identifiable, Hashable, Equatable {
    let id: Int
    let userId: Int

    let createdAt: Date
    let items: [Item]

    struct Item: Hashable, Equatable {
        let productId: Int
        let quantity: Int
    }
}
