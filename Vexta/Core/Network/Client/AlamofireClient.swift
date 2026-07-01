//
//  AlamofireClient.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Alamofire
import Foundation

struct AlamofireClient: NetworkClient {

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func request<T: Codable>(endpoint: some Endpoint) async throws(RemoteError) -> T {
        let url = endpoint.baseURL.appending(path: endpoint.path)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let task = session.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            headers: endpoint.headers
        )
        .validate(statusCode: 200...201)
        .validate(contentType: ["application/json"])
        .serializingDecodable(T.self, decoder: decoder)

        let result = await task.result

        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            throw RemoteError(from: error)
        }
    }
}
