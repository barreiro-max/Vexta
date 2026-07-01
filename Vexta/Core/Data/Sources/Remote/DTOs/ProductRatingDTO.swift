//
//  ProductRatingDTO.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

struct ProductRatingDTO: Codable, Hashable, Equatable {
    let rate: Double
    let count: Int

    var toDomain: ProductRating {
        ProductRating(rate: rate, count: count)
    }
}
