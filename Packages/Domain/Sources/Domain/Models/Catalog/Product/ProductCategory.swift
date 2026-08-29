//
//  ProductCategory.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public enum ProductCategory: String, Hashable, Equatable, Sendable {
    case mensClothing = "men's clothing"
    case womensClothing = "women's clothing"
    case jewelery
    case electronics

    public init?(rawValue: String) {
        switch rawValue {
        case "men's clothing":
            self = .mensClothing
        case "women's clothing":
            self = .womensClothing
        case "jewelery":
            self = .jewelery
        case "electronics":
            self = .electronics
        default:
            return nil
        }
    }
}
