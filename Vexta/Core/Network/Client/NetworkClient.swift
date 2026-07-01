//
//  NetworkClient.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol NetworkClient {
    func request<T: Codable>(endpoint: some Endpoint) async throws(RemoteError) -> T
}
