//
//  ProductCategory.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

public enum ProductCategoryDTO: String, Codable, Hashable, Equatable, Sendable {
    case mensClothing = "men's clothing"
    case womensClothing = "women's clothing"
    case jewelery
    case electronics

    public var toDomain: ProductCategory {
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

    public var toEntity: ProductCategoryEntity {
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
