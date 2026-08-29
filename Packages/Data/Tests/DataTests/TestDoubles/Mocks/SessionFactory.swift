//
//  MockURLProtocol.swift
//  VextaTests
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation
import Alamofire
@testable import Data

final class SessionFactory {

    func makeMockSession(
        responses: [
            (endpoint: FakeStoreEndpoint, stub: Data)
        ]
    ) -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        for response in responses {
            registerMockHandler(
                path: response.endpoint.path,
                data: response.stub
            )
        }

        return Session(configuration: configuration)
    }

    func registerMockHandler(
        path: String,
        data: Data,
        statusCode: Int = 200,
    ) {
        MockURLProtocol.register(path: path) { request in
            guard let url = request.url else {
                throw URLError(.badURL)
            }

            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!

            return (response, data)
        }
    }
}

