//
//  ProductDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct ProductDTO: Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let category: ProductCategoryDTO
    let rating: ProductRatingDTO
    let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case category
        case rating
        case imageURL = "image"
    }

    var toDomain: Product {
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

    var toEntity: ProductEntity {
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
