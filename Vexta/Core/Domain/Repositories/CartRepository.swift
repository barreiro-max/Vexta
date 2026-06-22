//
//  CartRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol CartRepository {
    func fetchAll() async throws -> [Cart]
    func fetch(cartId: Int) async throws -> Cart
}

