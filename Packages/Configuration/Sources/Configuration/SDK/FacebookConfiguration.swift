//
//  FacebookConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation
import FacebookCore
import Telemetry

public protocol FacebookConfigurable: Sendable {

    @MainActor func configure(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    )

    @MainActor func configureFacebookURL(
        openURLContexts URLContexts: Set<UIOpenURLContext>
    )
}

public struct FacebookConfiguration: FacebookConfigurable {

    public init() {}

    @MainActor public func configure(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) {
        let facebookDelegateConfigured = ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        if facebookDelegateConfigured {
            Log.auth.notice("ⓕ Facebook ApplicationDelegate configured")
        } else {
            Log.auth.fault("⛔️ Failed to configure Facebook ApplicationDelegate")
        }
    }

    @MainActor public func configureFacebookURL(
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let facebookURL = URLContexts.first?.url else { return }

        let facebookHandled = ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: facebookURL,
            sourceApplication: nil,
            annotation: URLContexts.first?.options.annotation
        )
        if facebookHandled {
            Log.auth.notice("ⓕ FacebookLogin URL configured")
        } else {
            Log.auth.fault("⛔️ Failed to configure FacebookLogin URL")
        }
    }
}
