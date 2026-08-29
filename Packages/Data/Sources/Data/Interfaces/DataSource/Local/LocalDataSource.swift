//
//  LocalDataSource.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import SwiftData

protocol LocalDataSource<Entity>: Actor {

    associatedtype Entity: TTLValidatable, DomainConvertable, PersistentModel

    var isEmpty: Bool { get throws(PersistenceError) }

    func write(_ entityId: PersistentIdentifier)         async throws(PersistenceError)
    func writeAll(_ entitiesIds: [PersistentIdentifier]) async throws(PersistenceError)
    func remove(_ entityId: PersistentIdentifier)        async throws(PersistenceError)
    func read(for id: Int)                               async throws(PersistenceError) -> Entity.DomainValue?
    func readAll()                                       async throws(PersistenceError) -> [Entity.DomainValue]?
    func invalidate()                                    async throws(PersistenceError)
}
