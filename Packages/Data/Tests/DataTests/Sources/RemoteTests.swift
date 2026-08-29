//
//  RemoteTests.swift
//  VextaTests
//
//  Created by MaxAdmin on 25.06.2026.
//

import Foundation
import Testing
import Alamofire
import Environment
@testable import Data

@Suite(.tags(.datasource))
struct RemoteTests {

    @Test func fakeStoreAPI_equalExpectedURL() async throws {
        let expectedURL = URL(string: "https://fakestoreapi.com")
        #expect(InfoPlistConfiguration.fakeStoreAPIURL == expectedURL)
    }

    @Suite
    struct EndPointTests {

        @Test(arguments: FakeStoreEndpoint.stubs)
        func fakeStoreEndPoints_equalExpectedPaths(
            endpoint: FakeStoreEndpoint,
            expectedPath: String
        ) async throws {
            #expect(endpoint.path == expectedPath)
        }
    }

    @Suite
    struct RequestTests {
        private let sut: RemoteDataSourceImpl

        init() {
            let mockSession = SessionFactory().makeMockSession(
                responses: [
                    (FakeStoreEndpoint.getProduct(withID: 1), ProductDTO.stubData),
                    (.getCart(withID: 1), CartDTO.stubData),
                    (.getUser(withID: 1), UserDTO.stubData)
                ]
            )
            let errorMapper = RemoteErrorMapper()
            let client = AlamofireClient(session: mockSession, errorMapper: errorMapper)

            self.sut = RemoteDataSourceImpl(client: client)
        }

        @Test func fetchFirstProduct_equalDecoded() async throws {
            let data = ProductDTO.stubData
            let decoded = try JSONDecoder().decode(ProductDTO.self, from: data)

            let fetched = try await sut.fetchProduct(id: 1)

            #expect(fetched == decoded)
        }

        @Test func fetchFirstCart_equalDecoded() async throws {
            let data = CartDTO.stubData

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decoded = try decoder.decode(CartDTO.self, from: data)

            let fetched = try await sut.fetchCart(id: 1)

            #expect(fetched == decoded)
        }

        @Test func fetchFirstUser_equalDecoded() async throws {
            let data = UserDTO.stubData
            let decoded = try JSONDecoder().decode(UserDTO.self, from: data)

            let fetched = try await sut.fetchUser(id: 1)

            #expect(fetched == decoded)
        }
    }
}
