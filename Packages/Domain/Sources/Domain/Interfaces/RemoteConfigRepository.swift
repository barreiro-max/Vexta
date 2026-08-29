//
//  RemoteConfigRepository.swift
//  Vexta
//
//  Created by MaxAdmin on 01.08.2026.
//

import Foundation

public protocol RemoteConfigRepository: Sendable {
    func observeConfigUpdates() async
    var configUpdates: AsyncStream<Set<String>> { get }

    func fetchAndActivate() async -> Bool
    func activate() async throws -> Bool
    func fetch() async throws -> Bool

    func configValue<T: Decodable>(forKey key: RemoteConfigKey) -> T?
    subscript<T: Decodable>(key: RemoteConfigKey) -> T? { get }
}
