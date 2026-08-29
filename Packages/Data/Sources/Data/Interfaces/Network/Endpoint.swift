//
//  EndPoint.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Alamofire
import Foundation
import Environment

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

extension Endpoint {
    public var baseURL: URL {
        InfoPlistConfiguration.fakeStoreAPIURL
    }

    var method: HTTPMethod { .get }

    var headers: HTTPHeaders? {
        ["Content-Type": "application/json"]
    }

    var parameters: Parameters? { nil }
}
