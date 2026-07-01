//
//  MockAlamofireClient.swift
//  VextaTests
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation
import Synchronization
@testable import Vexta

final class MockURLProtocol: URLProtocol {

    typealias Request = URLRequest
    typealias Response = (HTTPURLResponse, Data)
    typealias MockHandler = @Sendable (Request) throws -> Response

    struct MockHandlerKey: Hashable {
        let path: String
    }

    private static let handlersMutex = Mutex<[MockHandlerKey: MockHandler]>([:])

    static func register(path: String, handler: @escaping MockHandler) {
        let key = MockHandlerKey(path: path)
        handlersMutex.withLock { handlers in
            handlers[key] = handler
        }
    }

    static func unregister(path: String) {
        let key = MockHandlerKey(path: path)
        handlersMutex.withLock { handlers in
            _ = handlers.removeValue(forKey: key)
        }
    }

    static func invalidate() {
        handlersMutex.withLock { handlers in
            handlers.removeAll()
        }
    }

    private static func makeHandler(for path: String) -> MockHandler? {
        let key = MockHandlerKey(path: path)
        return handlersMutex.withLock { handlers in
            handlers[key]
        }
    }

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: (any URLProtocolClient)?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let path = request.url?.path() else {
            return false
        }
        return URLProtocol.property(forKey: path, in: request) == nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let path = request.url?.path() else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            Log.mockNetwork.warning("⛔️ Failed to receive path from URL")
            return
        }

        guard let handler = MockURLProtocol.makeHandler(for: path) else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            Log.mockNetwork.warning("⛔️ Failed to make handler")
            return
        }

        let mutableRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: path, in: mutableRequest)

        do {
            let (response, data) = try handler(mutableRequest as URLRequest)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
            Log.mockNetwork.info("✅ Loading data and receive response in \(String(describing: self.request.url))")
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            Log.mockNetwork.warning("⚠️ Receive error: \(error) in \(String(describing: self.request.url))")
        }
    }

    override func stopLoading() {}
}
