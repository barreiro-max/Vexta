//
//  NetworkError.swift
//  Domain
//
//  Created by MaxAdmin on 05.09.2026.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Equatable {
    case requiresConnection
    case noInternet

    public var errorDescription: String? {
        switch self {
        case .requiresConnection:
            String(localized: "Connection required.")
        case .noInternet:
            String(localized: "No internet connection.")
        }
    }
}
