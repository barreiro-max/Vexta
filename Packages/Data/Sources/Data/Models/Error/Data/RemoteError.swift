//
//  RemoteError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation

enum RemoteError: Error {
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
    case serverUnknown
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
        case .serverUnknown:
            UnknownError.unknown
        }

        return (underlyingError as NSError).code
    }
}


extension RemoteError: LocalizedError {

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
        case .serverUnknown:
            String(localized: "An unknown network error occurred.")
        }
    }

    var failureReason: String? {
        switch self {
        case .timeout:
            "NSURLErrorTimedOut (-1001): The connection timed out before receiving a response from the server."
        case .noConnection:
            "NSURLErrorNotConnectedToInternet (-1009): The device has no active internet connection."
        case .cancelled:
            "NSURLErrorCancelled (-999): The asynchronous network task was explicitly aborted or invalidated."
        case .badRequest:
            "HTTP 400 (Bad Request): The server cannot process the request due to malformed syntax or bad payloads."
        case .unauthorized:
            "HTTP 401 (Unauthorized): Authentication is required or has failed. Valid credentials are missing."
        case .notFound:
            "HTTP 404 (Not Found): The requested endpoint or resource could not be found on the server."
        case .decodingFailed:
            "HTTP 422 (Unprocessable Entity): The response was successfully received, but data parsing or validation failed."
        case .serverError:
            "HTTP 500 (Internal Server Error): The server encountered an unexpected condition that prevented it from fulfilling the request."
        case .badResponse:
            "HTTP 502 (Bad Gateway): The server received an invalid response from the upstream gateway or proxy."
        case .unavailable:
            "HTTP 503 (Service Unavailable): The server is temporarily unable to handle the request due to maintenance or overload."
        case .serverUnknown:
            "Unknown -1 (Unknown Error): An unhandled or custom networking error occurred."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .timeout:
            String(localized: "Please check your network stability and try again.")
        case .noConnection:
            String(localized: "Please verify your Wi-Fi or cellular network settings.")
        case .badRequest:
            String(localized: "Please double-check your input or try again later.")
        case .unauthorized:
            String(localized: "Please log in again to restore your session.")
        case .notFound:
            String(localized: "Please verify the request path or update the application.")
        case .cancelled:
            String(localized: "You can try initiating the request again if needed.")
        case .badResponse, .decodingFailed, .serverError, .unavailable, .serverUnknown:
            String(localized: "This seems to be a temporary server issue. Please try again.")
        }
    }
}

extension RemoteError: CaseIterable {}
