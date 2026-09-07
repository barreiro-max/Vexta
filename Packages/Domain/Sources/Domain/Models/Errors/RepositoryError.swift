//
//  RepositoryError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

public enum RepositoryError: Error, LocalizedError, Equatable {
    case noInternet
    case timeout
    case unauthenticated
    case notFound
    case serverError
    case storageFailure
    case dataCorrupted
    case cancelled
    case unknown(underlying: NSError)

    public var errorDescription: String? {
        switch self {
        case .noInternet:                      String(localized: "No internet connection.")
        case .timeout:                         String(localized: "Operation timed out.")
        case .unauthenticated:                 String(localized: "Session expired. Please log in again.")
        case .notFound:                        String(localized: "Requested item was not found.")
        case .serverError:                     String(localized: "Server encountered an error.")
        case .storageFailure:                  String(localized: "Failed to access local storage.")
        case .dataCorrupted:                   String(localized: "Data format is invalid or corrupted.")
        case .cancelled:                       String(localized: "Operation was cancelled.")
        case .unknown(let underlying):         underlying.localizedDescription
        }
    }
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

public extension RepositoryError {
    init(from error: any Error) {
        switch error {
        case let repositoryError as RepositoryError:
            self = repositoryError
        case let convertible as RepositoryErrorConvertible:
            self = convertible.asRepositoryError
        default:
            self = .unknown(underlying: error as NSError)
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
