//
//  ProductRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public protocol ProductRepository {
    func fetchAll() async throws(RepositoryError) -> [Product]
    func fetch(productId: Int) async throws(RepositoryError) -> Product
}
