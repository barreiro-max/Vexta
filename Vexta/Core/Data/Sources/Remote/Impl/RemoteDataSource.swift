//
//  RemoteDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation

protocol RemoteDataSource {

    func fetchProducts() async throws(RemoteError) -> [ProductDTO]
    func fetchCarts() async throws(RemoteError) -> [CartDTO]

    func fetchProduct(id: Int) async throws(RemoteError) -> ProductDTO
    func fetchCart(id: Int) async throws(RemoteError) -> CartDTO
    func fetchUser(id: Int) async throws(RemoteError) -> UserDTO
}
