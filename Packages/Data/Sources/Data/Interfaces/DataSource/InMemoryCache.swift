//
//  InMemoryCache.swift
//  Vexta
//
//  Created by MaxAdmin on 24.06.2026.
//

import Foundation

protocol InMemoryCache<Value>: Sendable {
    associatedtype Value: Identifiable, Sendable where Value.ID: Sendable

    func get(for key: Value.ID) -> Value?
    func getAll() -> [Value]?
    func set(_ value: Value)
    func setAll(_ values: [Value])
    func remove(for key: Value.ID)
}
