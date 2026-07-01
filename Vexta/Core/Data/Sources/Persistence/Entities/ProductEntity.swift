//
//  ProductEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData

@Model
final class ProductEntity: TTLValidatable, Sendable {
    @Attribute(.unique) var id: Int
    var title: String
    var _description: String
    var price: Double
    var category: ProductCategoryEntity
    var rate: Double
    var count: Int
    var imageURL: URL?
    var createdAt: Date

    init(
        id: Int,
        title: String,
        _description: String,
        price: Double,
        category: ProductCategoryEntity,
        rate: Double,
        count: Int,
        imageURL: URL? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self._description = _description
        self.price = price
        self.category = category
        self.rate = rate
        self.count = count
        self.imageURL = imageURL
        self.createdAt = createdAt
    }

    var toDomain: Product {
        Product(
            id: id,
            title: title,
            description: _description,
            price: price,
            category: category.toDomain,
            rating: ProductRating(rate: rate, count: count),
            imageURL: imageURL
        )
    }
}

extension ProductEntity: Equatable {
    public static func == (lhs: ProductEntity, rhs: ProductEntity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs._description == rhs._description &&
               lhs.price == rhs.price &&
               lhs.category == rhs.category &&
               lhs.rate == rhs.rate &&
               lhs.count == rhs.count &&
               lhs.imageURL == rhs.imageURL &&
               lhs.createdAt == rhs.createdAt
    }
}
