//
//  ProductDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

public struct ProductDTO: Codable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let description: String
    public let price: Double
    public let category: ProductCategoryDTO
    public let rating: ProductRatingDTO
    public let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case category
        case rating
        case imageURL = "image"
    }

    public var toDomain: Product {
        Product(
            id: id,
            title: title,
            description: description,
            price: price,
            category: category.toDomain,
            rating: rating.toDomain,
            imageURL: imageURL
        )
    }

    public var toEntity: ProductEntity {
        ProductEntity(
            id: id,
            title: title,
            _description: description,
            price: price,
            category: category.toEntity,
            rate: rating.rate,
            count: rating.count,
            imageURL: imageURL
        )
    }
}
