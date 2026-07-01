//
//  RemoteError.swift
//  Vexta
//
//  Created by MaxAdmin on 29.06.2026.
//

import Foundation
import Alamofire

enum RemoteError: LocalizedError {
    case noConnection
    case badRequest
    case decodingFailed
    case unknown

    init(from error: AFError) {
        switch error {

        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode:
                self = .badRequest
            default:
                self = .unknown
            }

        case .responseSerializationFailed:
            self = .decodingFailed

        case .explicitlyCancelled:
            self = .noConnection

        default:
            self = .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .badRequest:
            "Bad request."
        case .noConnection: 
            "No internet connection."
        case .decodingFailed:
            "Failed to decode data."
        case .unknown: 
            "An unknown error occurred."
        }
    }
}
