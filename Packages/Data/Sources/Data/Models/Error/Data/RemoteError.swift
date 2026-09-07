//
//  RemoteError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum RemoteError: Error, LocalizedError, Equatable {
    case timeout
    case noConnection
    case cancelled
    case badRequest
    case unauthorized
    case notFound
    case decodingFailed
    case serverError
    case badResponse
    case unavailable
    case serverUnknown(underlying: NSError)

    var errorDescription: String? {
        switch self {
        case .timeout:
            String(localized: "Request timed out.")
        case .noConnection:
            String(localized: "No internet connection.")
        case .badRequest:
            String(localized: "Bad request.")
        case .unauthorized:
            String(localized: "Session expired.")
        case .notFound:
            String(localized: "Resource not found.")
        case .decodingFailed:
            String(localized: "Failed to decode data.")
        case .serverError:
            String(localized: "Server error.")
        case .badResponse:
            String(localized: "Invalid server response.")
        case .unavailable:
            String(localized: "Server is temporarily unavailable.")
        case .cancelled:
            String(localized: "Request was cancelled.")
        case .serverUnknown(let underlying):
            underlying.localizedDescription
        }
    }

}

extension RemoteError: CustomNSError {

    static var errorDomain: String {
        String(reflecting: Self.self)
    }

    var errorCode: Int {

        let underlyingError: any Error = switch self {
        case .timeout:
            URLError(.timedOut)
        case .noConnection:
            URLError(.notConnectedToInternet)
        case .cancelled:
            URLError(.cancelled)
        case .badRequest:
            HTTPError.badRequest
        case .unauthorized:
            HTTPError.unauthorized
        case .notFound:
            HTTPError.notFound
        case .decodingFailed:
            HTTPError.unprocessableEntity
        case .serverError:
            HTTPError.internalServerError
        case .badResponse:
            HTTPError.badGateway
        case .unavailable:
            HTTPError.serviceUnavailable
        case .serverUnknown(let underlying):
            underlying
        }

        return (underlyingError as NSError).code
    }
}
