//
//  UnknownError.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

enum UnknownError: Int, Error {
    case unknown = -1
}

extension UnknownError: CustomNSError {

    static var errorDomain: String {
        String(reflecting: Self.self)
    }

    var errorCode: Int { self.rawValue }
}

extension UnknownError: LocalizedError {
    public var errorDescription: String? {
        String(localized: "An unexpected error occurred.")
    }

    public var failureReason: String? {
        String(localized: "The system encountered an unhandled exception or an undefined runtime state.")
    }

    public var recoverySuggestion: String? {
        String(localized: "Please try restarting the application or contact support if the problem persists.")
    }
}
