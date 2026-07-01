//
//  RepositoryError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum RepositoryError: LocalizedError {
    case databaseFailure(PersistenceError)
    case networkFailure(RemoteError)
    case unknown

    init(from error: some Error) {
        switch error {
        case let persistenceError as PersistenceError:
            self = .databaseFailure(persistenceError)

        case let remoteError as RemoteError:
            self = .networkFailure(remoteError)

        default:
            self = .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .databaseFailure(let persistenceError):
            persistenceError.localizedDescription
        case .networkFailure(let remoteError):
            remoteError.localizedDescription
        case .unknown:
            "An unexpected error occurred. Please try again."
        }
    }
}
