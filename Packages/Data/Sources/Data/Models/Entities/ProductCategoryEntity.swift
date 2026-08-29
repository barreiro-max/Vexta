//
//  ProductCategoryEntity.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation
import SwiftData
import Domain

public enum ProductCategoryEntity: String, Codable, Hashable, Equatable, Sendable, DomainConvertable {
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
}

