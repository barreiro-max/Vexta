//
//  FacebookConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 06.07.2026.
//

import Foundation

// MARK: - Shared imports
import Telemetry

// MARK: - SDK imports
import GoogleSignIn

public protocol GoogleConfigurable {
    @MainActor func configureGoogleURL(
        openURLContexts URLContexts: Set<UIOpenURLContext>
    )
}

public struct GoogleConfiguration: GoogleConfigurable {

    public init() {}

    public func configureGoogleURL(
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let googleURL = URLContexts.first?.url else { return }

        let googleHandled = GIDSignIn.sharedInstance.handle(googleURL)

        if googleHandled {
            Log.auth.notice("Ⓖ GIDSignIn URL configured")
        } else {
            Log.auth.fault("⛔️ Failed to configure GIDSignIn URL")
        }
    }
}
