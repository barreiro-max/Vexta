//
//  Product.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct Product: Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let category: ProductCategory
    let rating: ProductRating
    let imageURL: URL?
}
