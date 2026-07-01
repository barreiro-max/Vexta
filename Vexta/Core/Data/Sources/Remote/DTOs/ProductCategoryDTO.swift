//
//  ProductCategory.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

enum ProductCategoryDTO: String, Codable, Hashable, Equatable {
    case mensClothing = "men's clothing"
    case womensClothing = "women's clothing"
    case jewelery
    case electronics

    var toDomain: ProductCategory {
        switch self {
        case .mensClothing:
            .mensClothing
        case .womensClothing:
            .womensClothing
        case .jewelery:
            .jewelery
        case .electronics:
            .electronics
        }
    }

    var toEntity: ProductCategoryEntity {
        switch self {
        case .mensClothing:
            .mensClothing
        case .womensClothing:
            .womensClothing
        case .jewelery:
            .jewelery
        case .electronics:
            .electronics
        }
    }
}
