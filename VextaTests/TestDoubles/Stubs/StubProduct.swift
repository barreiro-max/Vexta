//
//  MockProduct.swift
//  VextaTests
//
//  Created by MaxAdmin on 25.06.2026.
//

@testable import Vexta

extension Product {

    static var stub: Product {
        .init(
            id: -1,
            title: "Computer",
            description: "Test Description",
            price: 15_000,
            category: .electronics,
            rating: .init(rate: 4.2, count: 124),
            imageURL: nil
        )
    }

    static var stubs: [Product] {
        [
            .init(
                id: 0,
                title: "Mens Casual Slim Fit T-Shirt",
                description: "Lightweight and breathable cotton blend shirt.",
                price: 1_500,
                category: .mensClothing,
                rating: .init(rate: 4.1, count: 259),
                imageURL: nil
            ),
            .init(
                id: 1,
                title: "Mens Cotton Jacket",
                description: "Great utility jacket for autumn and winter wear.",
                price: 4_800,
                category: .mensClothing,
                rating: .init(rate: 4.7, count: 500),
                imageURL: nil
            ),
            .init(
                id: 2,
                title: "Womens 3-in-1 Snowboard Jacket",
                description: "Waterproof and windproof winter coat with detachable fleece interior.",
                price: 7_200,
                category: .womensClothing,
                rating: .init(rate: 4.6, count: 340),
                imageURL: nil
            ),
            .init(
                id: 3,
                title: "Womens Solid Short Sleeve V-Neck",
                description: "100% Polyester, light and comfortable summer tee.",
                price: 1_200,
                category: .womensClothing,
                rating: .init(rate: 4.4, count: 120),
                imageURL: nil
            ),
            .init(
                id: 4,
                title: "John Hardy Men's Bracelet",
                description: "Classic Chain 18k Gold & Silver Medium Bracelet.",
                price: 55_000,
                category: .jewelery,
                rating: .init(rate: 4.9, count: 42),
                imageURL: nil
            ),
            .init(
                id: 5,
                title: "Solid Gold Petite Micropave Ring",
                description: "Satisfaction Guaranteed. Return or exchange any order within 30 days.",
                price: 18_000,
                category: .jewelery,
                rating: .init(rate: 4.7, count: 95),
                imageURL: nil
            ),
            .init(
                id: 6,
                title: "White Gold Plated Princess Wedding Ring",
                description: "Beautiful engagement ring crafted in sparkling CZ crystals.",
                price: 3_500,
                category: .jewelery,
                rating: .init(rate: 4.3, count: 112),
                imageURL: nil
            ),
            .init(
                id: 7,
                title: "WD 2TB External Hard Drive",
                description: "USB 3.0 and USB 2.0 Compatibility, fast data transfers.",
                price: 6_400,
                category: .electronics,
                rating: .init(rate: 4.5, count: 810),
                imageURL: nil
            ),
            .init(
                id: 8,
                title: "SanDisk SSD PLUS 1TB",
                description: "Easy upgrade for faster boot up, shutdown, and application response.",
                price: 8_900,
                category: .electronics,
                rating: .init(rate: 4.2, count: 230),
                imageURL: nil
            ),
            .init(
                id: 9,
                title: "Silicon Power 256GB SSD",
                description: "3D NAND flash technology high transfer speeds.",
                price: 2_800,
                category: .electronics,
                rating: .init(rate: 4.0, count: 142),
                imageURL: nil
            ),
            .init(
                id: 10,
                title: "Samsung 49-Inch Curved Gaming Monitor",
                description: "Super Ultrawide Dual QHD monitor with 120Hz refresh rate.",
                price: 95_000,
                category: .electronics,
                rating: .init(rate: 4.8, count: 56),
                imageURL: nil
            )
        ]
    }
}
