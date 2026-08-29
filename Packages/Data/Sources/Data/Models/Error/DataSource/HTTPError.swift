//
//  HTTPError.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

enum HTTPError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case unprocessableEntity = 422

    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
}

extension HTTPError: CustomNSError {

    static var errorDomain: String {
        String(reflecting: Self.self)
    }

    var errorCode: Int { self.rawValue }
}

extension HTTPError: LocalizedError {

    var errorDescription: String? {

        let statusText: String = switch self {
        case .badRequest:          "Bad Request"
        case .unauthorized:        "Unauthorized"
        case .notFound:            "Not Found"
        case .unprocessableEntity: "Unprocessable Entity"
        case .internalServerError: "Internal Server Error"
        case .badGateway:          "Bad Gateway"
        case .serviceUnavailable:  "Service Unavailable"
        }

        return "\(errorCode) \(statusText)"
    }
}

extension HTTPError: CaseIterable {}
