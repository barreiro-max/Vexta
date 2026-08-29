//
//  SplashError.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//


public enum SplashError: Error {
    case noInternetConnection
    case maintenanceMode(message: String)
    case forceUpdateRequired(storeURL: URL)
}

extension SplashError: CustomNSError {
    public static var errorDomain: String {
        String(describing: Self.self)
    }

    public var errorCode: Int {
        switch self {
        case .noInternetConnection: 401
        case .maintenanceMode: 500
        case .forceUpdateRequired: 501
        }
    }
}

extension SplashError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            String(localized: "No internet connection.")
        case .maintenanceMode:
            String(localized: "App is under maintenance.")
        case .forceUpdateRequired:
            String(localized: "Update required.")
        }
    }

    public var failureReason: String? {
        switch self {
        case .noInternetConnection:
            "Device is offline or network is unreachable."
        case .maintenanceMode(let message):
            message
        case .forceUpdateRequired(let storeURL):
            "Current app version is no longer supported. Store URL: \(storeURL.absoluteString)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noInternetConnection:
            String(localized: "Check your network settings and try again.")
        case .maintenanceMode:
            String(localized: "Please try again later.")
        case .forceUpdateRequired:
            String(localized: "Please update the app from the App Store to continue.")
        }
    }
}