//
//  InfoPlistConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 22.06.2026.
//

import Foundation

public enum InfoPlistConfiguration {

    public static var fakeStoreAPIURL: URL {
        switch AppEnvironment.current {
        case .dev, .test:
            return URL(string: "https://fakestoreapi.com")!
        case .stage, .prod:
            return InfoPlistKey.fakeStoreAPI.url
        }
    }

    public static var revenueCatAPIKey: String {
        InfoPlistKey.revenueCat.value
    }

    public static var currentAppEnvironment: String {
        InfoPlistKey.appEnvironment.value
    }

    // we pass property for analytics flag because firebase doesn't provide to us
    public static var isAnalyticsCollectionEnabled: Bool {
        InfoPlistKey.analyticsCollection.firebaseFeatureIsEnabled
    }
}

fileprivate enum InfoPlistKey: String {
    case fakeStoreAPI = "FAKESTORE_API_URL"
    case revenueCat   = "REVENUE_CAT_API_KEY"

    case appEnvironment = "APP_ENVIRONMENT"

    case analyticsCollection = "IS_ANALYTICS_ENABLED"

    private var title: String { self.rawValue }

    var url: URL {
        guard let urlString = bundleString,
              let url = URL(string: urlString) else {
            fatalError("⚠️ Config: \(title) is not found.")
        }
        return url
    }

    var value: String {
        guard let key = bundleString else {
            fatalError("⚠️ Config: \(title) is not found.")
        }
        return key
    }

    var firebaseFeatureIsEnabled: Bool {
        guard let key = bundleString else {
            fatalError("⚠️ Config: \(title) is not found.")
        }
        return key == "YES" ? true : false
    }

    private var bundleString: String? {
        Bundle.main.infoDictionary?[title] as? String
    }
}
