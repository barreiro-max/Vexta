//
//  ProductCategoryEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData

enum ProductCategoryEntity: String, Codable, Hashable, Equatable, Sendable {
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
}

