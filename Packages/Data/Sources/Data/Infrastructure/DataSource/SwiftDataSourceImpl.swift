//
//  SwiftDataSourceImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import SwiftData
import Domain

actor SwiftDataSourceImpl<T: TTLValidatable & DomainConvertable & PersistentModel>: LocalDataSource {
    typealias Entity = T

    nonisolated private let modelExecutor: any ModelExecutor
    nonisolated private let modelContainer: ModelContainer

    private var modelContext: ModelContext { modelExecutor.modelContext }

    private let TTL: TimeInterval

    init(
        modelContainer: ModelContainer,
        TTL: TimeInterval = 86400
    ) {
        let modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
        self.TTL = TTL
    }

    var isEmpty: Bool {
        get throws(PersistenceError) {
            do {
                let descriptor = FetchDescriptor<Entity>()
                let count = try modelContext.fetchCount(descriptor)
                return count == 0
            } catch {
                let persistenceError = PersistenceError(from: error)

                throw persistenceError
            }
        }
    }

    func write(_ entityId: PersistentIdentifier) throws(PersistenceError) {
        do throws(PersistenceError) {
            try invalidate()

            guard let entity = modelContext.model(for: entityId) as? T else {
                throw .writingToFile
            }
            modelContext.insert(entity)
            try save()

        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    func writeAll(_ entitiesIds: [PersistentIdentifier]) throws(PersistenceError) {
        do throws(PersistenceError) {
            try invalidate()

            let entities = entitiesIds.compactMap { entityId in
                modelContext.model(for: entityId) as? T
            }

            for entity in entities {
                modelContext.insert(entity)
            }
            try save()
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    func remove(_ entityId: PersistentIdentifier) throws(PersistenceError) {
        do throws(PersistenceError) {
            try invalidate()

            if let entity = modelContext.model(for: entityId) as? T {
                modelContext.delete(entity)
                try save()
            }
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    func read(for id: Int) throws(PersistenceError) -> T.DomainValue? {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        let validPredicate = #Predicate<Entity> {
            $0.id == id && $0.createdAt > boundaryDate
        }

        var validDescriptor = FetchDescriptor<Entity>(predicate: validPredicate)
        validDescriptor.fetchLimit = 1

        do {
            return try modelContext
                .fetch(validDescriptor)
                .first?
                .toDomain
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    func readAll() throws(PersistenceError) -> [T.DomainValue]? {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        do {
            let sortDescriptor = SortDescriptor<Entity>(\.id, order: .forward)
            let descriptor = FetchDescriptor<Entity>(sortBy: [sortDescriptor])

            let allEntities = try modelContext.fetch(descriptor)

            guard !allEntities.isEmpty else { return nil }

            let allValid = allEntities.allSatisfy { $0.createdAt > boundaryDate }
            guard allValid else { return nil }

            return allEntities.map(\.toDomain)
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    func invalidate() throws(PersistenceError) {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        let invalidPredicate = #Predicate<Entity> {
            $0.createdAt < boundaryDate
        }

        do {
            try modelContext.delete(model: Entity.self, where: invalidPredicate)
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }

    private func save() throws(PersistenceError) {
        do {
            if modelContext.hasChanges {
                try modelContext.save()
            }
        } catch {
            let persistenceError = PersistenceError(from: error)

            throw persistenceError
        }
    }
}
