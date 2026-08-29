//
//  Product.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public struct Product: Identifiable, Hashable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let description: String
    public let price: Double
    public let category: ProductCategory
    public let rating: ProductRating
    public let imageURL: URL?

    public init(
        id: Int,
        title: String,
        description: String,
        price: Double,
        category: ProductCategory,
        rating: ProductRating,
        imageURL: URL?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.rating = rating
        self.imageURL = imageURL
    }
}
