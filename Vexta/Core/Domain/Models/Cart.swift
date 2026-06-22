//
//  CartItem.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct Cart: Identifiable, Hashable {
    let id: Int
    let userId: Int

    let date: Date
    let items: [Item]

    struct Item: Hashable {
        let productId: Int
        let quantity: Int
    }
}
