//
//  RemoteErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 18.07.2026.
//

import Foundation
import Alamofire
import Domain

extension RemoteError {

    init(from error: any Error) {
        switch error {

        case let afError as AFError:
            self.init(from: afError)

        case let urlError as URLError:
            self.init(from: urlError)

        default:
            self = .serverUnknown
        }
    }

    private init(from afError: AFError) {
        switch afError {

        case .explicitlyCancelled,
             .sessionDeinitialized:
            self = .cancelled

        case let .responseValidationFailed(reason):
            guard case let .unacceptableStatusCode(statusCode) = reason else {
                self = .serverUnknown
                return
            }

            self.init(from: statusCode)

        case .responseSerializationFailed:
            self = .decodingFailed

        case .invalidURL,
             .urlRequestValidationFailed,
             .parameterEncodingFailed,
             .parameterEncoderFailed,
             .multipartEncodingFailed:
            self = .badRequest

        case .serverTrustEvaluationFailed:
            self = .serverError

        case .sessionTaskFailed(_),
             .sessionInvalidated(_?):
            self = .noConnection

        case let .createUploadableFailed(underlyingError),
             let .createURLRequestFailed(underlyingError),
             let .requestAdaptationFailed(underlyingError):
            self.init(from: (underlyingError as NSError).code)

        case let .requestRetryFailed(retryError, _):
            self.init(from: (retryError as NSError).code)

        case let .downloadedFileMoveFailed(underlyingError, _, _):
            self.init(from: (underlyingError as NSError).code)

        default:
            self = .serverUnknown
        }
    }

    private init(from urlError: URLError) {
        switch urlError.code {

        case .cancelled:
            self = .cancelled

        case .timedOut:
            self = .timeout

        case .notConnectedToInternet,
             .cannotConnectToHost,
             .cannotLoadFromNetwork,
             .cannotFindHost,
             .appTransportSecurityRequiresSecureConnection,
             .networkConnectionLost,
             .secureConnectionFailed,
             .dnsLookupFailed,
             .callIsActive,
             .dataNotAllowed,
             .internationalRoamingOff:
            self = .noConnection

        case .cannotDecodeRawData,
             .cannotDecodeContentData,
             .cannotParseResponse,
             .downloadDecodingFailedMidStream,
             .downloadDecodingFailedToComplete:
            self = .decodingFailed

        case .clientCertificateRejected,
             .clientCertificateRequired,
             .userAuthenticationRequired,
             .userCancelledAuthentication:
            self = .unauthorized

        case .resourceUnavailable,
             .zeroByteResource,
             .fileDoesNotExist,
             .fileIsDirectory,
             .noPermissionsToReadFile,
             .cannotCreateFile,
             .cannotOpenFile,
             .cannotCloseFile,
             .cannotWriteToFile,
             .cannotRemoveFile,
             .cannotMoveFile:
            self = .unavailable

        case .badURL,
             .unsupportedURL,
             .requestBodyStreamExhausted,
             .dataLengthExceedsMaximum:
            self = .badRequest

        case .badServerResponse,
             .httpTooManyRedirects,
             .redirectToNonExistentLocation:
            self = .badResponse

        default:
            self = .serverUnknown
        }
    }

    private init(from afStatusCode: Int) {
        let rawNetworkError = HTTPError(rawValue: afStatusCode)
        self = switch rawNetworkError {
            case .badRequest:          .badRequest
            case .unauthorized:        .unauthorized
            case .notFound:            .notFound
            case .unprocessableEntity: .decodingFailed
            case .internalServerError: .serverError
            case .badGateway:          .badResponse
            case .serviceUnavailable:  .unavailable
            case nil:                  .serverUnknown
        }
    }
}

extension RemoteError: RepositoryErrorConvertible {

    public var asRepositoryError: RepositoryError {
        switch self {
        case .noConnection:                      .noInternet
        case .timeout:                            .timeout
        case .unauthorized:                       .unauthenticated
        case .notFound:                           .notFound
        case .serverError, .badResponse, .unavailable: .serverError
        case .decodingFailed:                     .dataCorrupted
        case .cancelled:                          .cancelled
        case .badRequest, .serverUnknown:         .unknown
        }
    }
}
