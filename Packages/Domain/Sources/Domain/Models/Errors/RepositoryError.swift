//
//  RepositoryError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

public enum RepositoryError: Error {
    case noInternet
    case timeout
    case unauthenticated
    case notFound
    case serverError

    case storageFailure
    case dataCorrupted

    case cancelled
    case unknown
}

extension RepositoryError: CustomNSError {

    public static var errorDomain: String {
        String(reflecting: Self.self)
    }

    public var errorCode: Int {
        switch self {
        case .noInternet:      1001
        case .timeout:         1002
        case .unauthenticated: 1003
        case .notFound:        1004
        case .serverError:     1005
        case .storageFailure:  2001
        case .dataCorrupted:   2002
        case .cancelled:       3001
        case .unknown:         9999
        }
    }
}

extension RepositoryError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noInternet:      String(localized: "No internet connection.")
        case .timeout:         String(localized: "Operation timed out.")
        case .unauthenticated: String(localized: "Session expired. Please log in again.")
        case .notFound:        String(localized: "Requested item was not found.")
        case .serverError:     String(localized: "Server encountered an error.")
        case .storageFailure:  String(localized: "Failed to access local storage.")
        case .dataCorrupted:   String(localized: "Data format is invalid or corrupted.")
        case .cancelled:       String(localized: "Operation was cancelled.")
        case .unknown:         String(localized: "An unexpected error occurred.")
        }
    }

    public var failureReason: String? {
        switch self {
        case .noInternet:      "Device is offline or unreachable."
        case .timeout:         "The request took too long to complete."
        case .unauthenticated: "Authentication token is missing or invalid."
        case .notFound:        "Resource does not exist on server or local database."
        case .serverError:     "Remote server returned a 5xx status code."
        case .storageFailure:  "Read/write operation on local persistent store failed."
        case .dataCorrupted:   "Data mapping or decoding failed."
        case .cancelled:       "Task was explicitly aborted."
        case .unknown:         "An unclassified domain-level error occurred."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noInternet, .timeout:
            String(localized: "Check your network settings and try again.")
        case .unauthenticated:
            String(localized: "Please log in again.")
        case .notFound, .dataCorrupted, .cancelled:
            String(localized: "Try repeating the action.")
        case .serverError, .storageFailure, .unknown:
            String(localized: "Please try again later or restart the app.")
        }
    }
}

extension RepositoryError: CaseIterable {}

public extension RepositoryError {
    init(from error: any Error) {
        switch error {
        case let repositoryError as RepositoryError:
            self = repositoryError
        case let convertible as RepositoryErrorConvertible:
            self = convertible.asRepositoryError
        default:
            self = .unknown
        }
    }
}

// did this for crashlytics with additional info about error
public extension RepositoryError {
    var asReportable: NSError {
        var userInfo = self.errorUserInfo
        userInfo[NSUnderlyingErrorKey] = self as NSError

        return NSError(
            domain: RepositoryError.errorDomain,
            code: self.errorCode,
            userInfo: userInfo
        )
    }
}
