//
//  LocalDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import SwiftData

protocol LocalDataSource<Entity>: Actor {

    associatedtype Entity: TTLValidatable, Sendable

    var isEmpty: Bool { get throws(PersistenceError) }

    func write(_ entity: Entity) async throws(PersistenceError)
    func writeAll(_ entities: [Entity]) async throws(PersistenceError)
    func remove(_ entity: Entity) async throws(PersistenceError)
    func read(for id: Int) async throws(PersistenceError) -> Entity?
    func readAll() async throws(PersistenceError) -> [Entity]?
    func invalidate() async throws(PersistenceError)
}
