//
//  InMemoryModelContainer.swift
//  VextaTests
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation
import SwiftData

extension ModelContainer {

    static func makeInMemoryContainer<Entity: Equatable & PersistentModel>(
        for type: Entity.Type
    ) throws -> ModelContainer {
        let schema = Schema([type])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: config)
    }
}

