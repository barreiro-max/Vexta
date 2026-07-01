//
//  PersistenceError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum PersistenceError: LocalizedError {
    case savingContext
    case writingToFile
    case deletingFromFile
    case readingData
    case invalidation

    var errorDescription: String? {
        switch self {
        case .savingContext:
            "Failed to save context."
        case .writingToFile:
            "Failed to write to file."
        case .deletingFromFile:
            "Failed to delete from file."
        case .readingData:
            "Failed to read data."
        case .invalidation:
            "Failed to invalidate."
        }
    }
}
