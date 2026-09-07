//
//  PersistenceError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum PersistenceError: Error, LocalizedError, Equatable {
    case internalStore
    case writingToFile
    case invalidated
    case cancelled
    case deletingFromFile
    case migrationFailed
    case savingContext
    case readingData
    case unknown(underlying: NSError)

    var errorDescription: String? {
        switch self {
        case .savingContext:
            String(localized: "Failed to save context.")
        case .writingToFile:
            String(localized: "Failed to write to file.")
        case .deletingFromFile:
            String(localized: "Failed to delete from file.")
        case .readingData:
            String(localized: "Failed to read data.")
        case .invalidated:
            String(localized: "Failed to validate cache session.")
        case .internalStore:
            String(localized: "Internal database store error.")
        case .cancelled:
            String(localized: "The operation was cancelled.")
        case .migrationFailed:
            String(localized: "Database migration failed.")
        case .unknown(let underlying):
            underlying.localizedDescription
        }
    }
}

extension PersistenceError: CustomNSError {

    static var errorDomain: String {
        String(reflecting: Self.self)
    }

    var errorCode: Int {

        let underlyingError: any Error = switch self {
        case .internalStore:
            SQLiteError.internal
        case .writingToFile:
            SQLiteError.perm
        case .invalidated:
            SQLiteError.busy
        case .cancelled:
            SQLiteError.interrupt
        case .deletingFromFile:
            SQLiteError.inputOutputError
        case .migrationFailed:
            SQLiteError.schema
        case .savingContext:
            SQLiteError.constraint
        case .readingData:
            SQLiteError.notaDB
        case .unknown(let underlying):
            underlying
        }

        return (underlyingError as NSError).code
    }
}
