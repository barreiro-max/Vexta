//
//  PersistenceError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum PersistenceError: Error {
    case internalStore
    case writingToFile
    case invalidated
    case cancelled
    case deletingFromFile
    case migrationFailed
    case savingContext
    case readingData
    case unknown
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
        case .unknown:
            UnknownError.unknown
        }

        return (underlyingError as NSError).code
    }
}

extension PersistenceError: LocalizedError {

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
        case .unknown:
            String(localized: "An unknown persistence error occurred.")
        }
    }

    var failureReason: String? {
        switch self {
        case .internalStore:
            "1 SQLITE_INTERNAL: Generic SQL error or missing database schema."
        case .writingToFile:
            "3 SQLITE_PERM: Access permission denied by the operating system."
        case .invalidated:
            "5 SQLITE_BUSY: The database file is locked or the cache session has expired."
        case .cancelled:
            "9 SQLITE_INTERRUPT: Operation terminated internally by an interrupt request."
        case .deletingFromFile:
            "10 SQLITE_IOERR: Low-level disk I/O error occurred during file manipulation."
        case .migrationFailed:
            "17 SQLITE_SCHEMA: The database schema changed or is incompatible with the store version."
        case .savingContext:
            "19 SQLITE_CONSTRAINT: Data validation failed or a constraint was violated."
        case .readingData:
            "26 SQLITE_NOTADB: File is not a valid database or the file header is corrupted."
        case .unknown:
            "-1 UNKNOWN: An unhandled or custom persistence error occurred."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .savingContext, .invalidated, .unknown:
            String(localized: "Try reloading the screen or restarting the application.")
        case .writingToFile:
            String(localized: "Check if your device has enough free space available.")
        case .deletingFromFile, .readingData:
            String(localized: "Ensure the file isn't open in another process and try again.")
        case .internalStore, .migrationFailed:
            String(localized: "The database schema might be corrupted. Reinstalling the application may be required if the issue persists.")
        case .cancelled:
            String(localized: "Retry the action if necessary.")
        }
    }
}

extension PersistenceError: CaseIterable {}
