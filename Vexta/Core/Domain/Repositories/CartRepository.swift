//
//  CartRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol CartRepository {
    func fetchAll() async throws(RepositoryError) -> [Cart]
    func fetch(cartId: Int) async throws(RepositoryError) -> Cart
}

