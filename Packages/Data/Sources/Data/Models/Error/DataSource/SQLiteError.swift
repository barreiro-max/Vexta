//
//  SQLiteError.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

enum SQLiteError: Int, Error, LocalizedError, Equatable {
    case `internal` = 1
    case perm = 3
    case busy = 5
    case interrupt = 9
    case inputOutputError = 10
    case schema = 17
    case constraint = 19
    case notaDB = 26

    var errorDescription: String? {
        let statusText = switch self {
        case .internal:         "SQLITE_INTERNAL"
        case .perm:             "SQLITE_PERM"
        case .busy:             "SQLITE_BUSY"
        case .interrupt:        "SQLITE_INTERRUPT"
        case .inputOutputError: "SQLITE_IOERR"
        case .schema:           "SQLITE_SCHEMA"
        case .constraint:       "SQLITE_CONSTRAINT"
        case .notaDB:           "SQLITE_NOTADB"
        }
        return "\(errorCode) \(statusText)"
    }
}

extension SQLiteError: CustomNSError {

    static var errorDomain: String {
        String(reflecting: Self.self)
    }
    
    var errorCode: Int { self.rawValue }
}
