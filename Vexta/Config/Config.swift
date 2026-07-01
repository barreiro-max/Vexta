//
//  Config.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

enum Config {
    static var fakeStoreAPI: URL {
        guard let urlString = Bundle.main.infoDictionary?["FAKESTORE_API_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Config: FakeStoreAPI URL is not found")
        }
        return url
    }
}
