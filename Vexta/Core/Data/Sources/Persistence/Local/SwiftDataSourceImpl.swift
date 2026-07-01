//
//  SwiftDataSourceImpl.swift
//  Vexta
//
//  Created by MaxAdmin on 23.06.2026.
//

import Foundation
import SwiftData

actor SwiftDataSourceImpl<T: TTLValidatable & Sendable>: LocalDataSource {

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
                let descriptor = FetchDescriptor<T>()
                let count = try modelContext.fetchCount(descriptor)
                return count == 0
            } catch {
                throw .readingData
            }
        }
    }

    func write(_ entity: T) throws(PersistenceError) {
        do {
            try invalidate()
            modelContext.insert(entity)
            try save()
        } catch {
            throw .writingToFile
        }
    }

    func writeAll(_ entities: [T]) throws(PersistenceError) {
        do throws(PersistenceError) {
            try invalidate()
            for entity in entities {
                modelContext.insert(entity)
            }
            try save()
        } catch {
            throw .writingToFile
        }
    }

    func remove(_ entity: T) throws(PersistenceError) {
        do throws(PersistenceError) {
            try invalidate()
            modelContext.delete(entity)
            try save()
        } catch {
            throw .deletingFromFile
        }
    }

    func read(for id: Int) throws(PersistenceError) -> T? {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        let validPredicate = #Predicate<T> {
            $0.id == id && $0.createdAt > boundaryDate
        }

        var validDescriptor = FetchDescriptor<T>(predicate: validPredicate)
        validDescriptor.fetchLimit = 1

        do {
            return try modelContext.fetch(validDescriptor).first
        } catch {
            throw .readingData
        }
    }

    func readAll() throws(PersistenceError) -> [T]? {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        do {
            let sortDescriptor = SortDescriptor<T>(\.id, order: .forward)
            let descriptor = FetchDescriptor<T>(sortBy: [sortDescriptor])

            let allEntities = try modelContext.fetch(descriptor)

            guard !allEntities.isEmpty else { return nil }

            let allValid = allEntities.allSatisfy { $0.createdAt > boundaryDate }
            guard allValid else { return nil }

            return allEntities
        } catch {
            throw .readingData
        }
    }

    func invalidate() throws(PersistenceError) {
        let boundaryDate = Date().addingTimeInterval(-TTL)

        let invalidPredicate = #Predicate<T> {
            $0.createdAt < boundaryDate
        }

        do {
            try modelContext.delete(model: T.self, where: invalidPredicate)
        } catch {
            throw .invalidation
        }
    }

    private func save() throws(PersistenceError) {
        do {
            if modelContext.hasChanges {
                try modelContext.save()
            }
        } catch {
            throw .savingContext
        }
    }
}
