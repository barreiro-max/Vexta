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
public final class ProductEntity: TTLValidatable, DomainConvertable {
    @Attribute(.unique) public var id: Int
    public var title: String
    public var _description: String
    public var price: Double
    public var category: ProductCategoryEntity
    public var rate: Double
    public var count: Int
    public var imageURL: URL?
    public var createdAt: Date

    public init(
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

    public var toDomain: Product {
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
