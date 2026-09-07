//
//  SplashError.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import Foundation

public enum SplashError: Error, LocalizedError, Equatable {
    case noInternetConnection
    case maintenanceMode(message: String)
    case forceUpdateRequired(storeURL: URL)

    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            String(localized: "No internet connection.")
        case .maintenanceMode(let message):
            String(localized: "App is under maintenance, message: \(message)")
        case .forceUpdateRequired(let url):
            String(localized: "Update required, url: \(url.absoluteString)")
        }
    }
}

extension SplashError: CustomNSError {
    public static var errorDomain: String {
        String(describing: Self.self)
    }

    public var errorCode: Int {
        switch self {
        case .noInternetConnection: 401
        case .maintenanceMode:      402
        case .forceUpdateRequired:  403
        }
    }
}
