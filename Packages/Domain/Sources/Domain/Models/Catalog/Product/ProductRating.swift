//
//  ProductRating.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public struct ProductRating: Hashable, Equatable, Sendable {
    public let rate: Double
    public let count: Int

    public init(rate: Double, count: Int) {
        self.rate = rate
        self.count = count
    }
}
