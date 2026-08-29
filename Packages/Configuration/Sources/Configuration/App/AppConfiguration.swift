//
//  AppConfiguration.swift
//  Vexta
//
//  Created by MaxAdmin on 11.07.2026.
//

import Foundation
import UIKit
import Telemetry

public struct AppConfiguration: Sendable {

    private let firebase: FirebaseConfigurable
    private let revenueCat: RevenueCatConfigurable
    private let notification: NotificationConfigurable
    private let facebook: FacebookConfigurable

    init(
        firebase: FirebaseConfigurable,
        revenueCat: RevenueCatConfigurable,
        notification: NotificationConfigurable,
        facebook: FacebookConfigurable
    ) {
        self.firebase = firebase
        self.revenueCat = revenueCat
        self.notification = notification
        self.facebook = facebook
    }

    @MainActor public func configureApp(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) {
        firebase.configureFirebaseApp()
        Task {
            async let configuredFirebaseFeatures: Void = firebase.configureFirebaseFeatures()
            async let configuredRevenueCat: Void       = revenueCat.configure()
            async let configuredNotification: Void     = notification.configure()
            async let configuredFacebook: Void         = facebook.configure(
                application, didFinishLaunchingWithOptions: launchOptions
            )

            _ = await (
                configuredFirebaseFeatures,
                configuredRevenueCat,
                configuredNotification,
                configuredFacebook
            )
            Log.system.notice("✅ App successfully is configured with: \(Task.currentPriority.description)")
        }
    }
}
