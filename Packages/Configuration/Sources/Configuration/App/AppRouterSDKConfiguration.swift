//
//  AppRouterSDKConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation
import UIKit

public struct AppRouterSDKConfiguration {

    private let google: GoogleConfigurable
    private let facebook: FacebookConfigurable

    init(
        google: GoogleConfigurable,
        facebook: FacebookConfigurable
    ) {
        self.google = google
        self.facebook = facebook
    }

    @MainActor
    public func configureRoutingSDKs(
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        google.configureGoogleURL(
            openURLContexts: URLContexts
        )

        facebook.configureFacebookURL(
            openURLContexts: URLContexts
        )
    }
}
