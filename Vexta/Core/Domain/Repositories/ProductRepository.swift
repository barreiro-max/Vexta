//
//  ProductRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol ProductRepository {
    func fetchAll() async throws -> [Product]
    func fetch(productId: Int) async throws -> Product
}
