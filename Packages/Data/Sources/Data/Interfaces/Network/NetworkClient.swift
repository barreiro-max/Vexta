//
//  NetworkClient.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

protocol NetworkClient: Sendable {
    func request<T: Codable & Sendable>(endpoint: some Endpoint) async throws(RemoteError) -> T
}
