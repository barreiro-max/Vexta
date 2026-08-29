//
//  ProductRatingDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation
import Domain

public struct ProductRatingDTO: Codable, Hashable, Equatable, Sendable {
    public let rate: Double
    public let count: Int

    public var toDomain: ProductRating {
        ProductRating(rate: rate, count: count)
    }
}
