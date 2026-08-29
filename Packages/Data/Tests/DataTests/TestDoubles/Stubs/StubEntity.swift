//
//  MockEntity.swift
//  VextaTests
//
//  Created by MaxAdmin on 25.06.2026.
//

@testable import Data

extension ProductEntity {

    static var stub: ProductEntity {
        .init(
            id: 0,
            title: "Computer",
            _description: "Test Description",
            price: 15_000.0,
            category: .electronics,
            rate: 4.2,
            count: 124
        )
    }

    static var stubs: [ProductEntity] {
        [
            .init(
                id: 0,
                title: "Mens Casual Slim Fit T-Shirt",
                _description: "Lightweight and breathable cotton blend shirt.",
                price: 1_500.0,
                category: .mensClothing,
                rate: 4.1,
                count: 259
            ),
            .init(
                id: 1,
                title: "Mens Cotton Jacket",
                _description: "Great utility jacket for autumn and winter wear.",
                price: 4_800.0,
                category: .mensClothing,
                rate: 4.7,
                count: 500
            ),
            .init(
                id: 2,
                title: "Womens 3-in-1 Snowboard Jacket",
                _description: "Waterproof and windproof winter coat with detachable fleece interior.",
                price: 7_200.0,
                category: .womensClothing,
                rate: 4.6,
                count: 340
            ),
            .init(
                id: 3,
                title: "Womens Solid Short Sleeve V-Neck",
                _description: "100% Polyester, light and comfortable summer tee.",
                price: 1_200.0,
                category: .womensClothing,
                rate: 4.4,
                count: 120
            ),
            .init(
                id: 4,
                title: "John Hardy Men's Bracelet",
                _description: "Classic Chain 18k Gold & Silver Medium Bracelet.",
                price: 55_000.0,
                category: .jewelery,
                rate: 4.9,
                count: 42
            ),
            .init(
                id: 5,
                title: "Solid Gold Petite Micropave Ring",
                _description: "Satisfaction Guaranteed. Return or exchange any order within 30 days.",
                price: 18_000.0,
                category: .jewelery,
                rate: 4.7,
                count: 95
            ),
            .init(
                id: 6,
                title: "White Gold Plated Princess Wedding Ring",
                _description: "Beautiful engagement ring crafted in sparkling CZ crystals.",
                price: 3_500.0,
                category: .jewelery,
                rate: 4.3,
                count: 112
            ),
            .init(
                id: 7,
                title: "WD 2TB External Hard Drive",
                _description: "USB 3.0 and USB 2.0 Compatibility, fast data transfers.",
                price: 6_400.0,
                category: .electronics,
                rate: 4.5,
                count: 810
            ),
            .init(
                id: 8,
                title: "SanDisk SSD PLUS 1TB",
                _description: "Easy upgrade for faster boot up, shutdown, and application response.",
                price: 8_900.0,
                category: .electronics,
                rate: 4.2,
                count: 230
            ),
            .init(
                id: 9,
                title: "Silicon Power 256GB SSD",
                _description: "3D NAND flash technology high transfer speeds.",
                price: 2_800.0,
                category: .electronics,
                rate: 4.0,
                count: 142
            ),
            .init(
                id: 10,
                title: "Samsung 49-Inch Curved Gaming Monitor",
                _description: "Super Ultrawide Dual QHD monitor with 120Hz refresh rate.",
                price: 95_000.0,
                category: .electronics,
                rate: 4.8,
                count: 56
            )
        ]
    }
}
