//
//  ConfigContainer.swift
//  Vexta
//
//  Created by MaxAdmin on 25.07.2026.
//

import Foundation

public final class ConfigContainer {
    public init() {}

    lazy var firebaseConfig     = FirebaseConfiguration()
    lazy var revenueCatConfig   = RevenueCatConfiguration()
    lazy var notificationConfig = NotificationConfiguration()
    lazy var googleConfig       = GoogleConfiguration()
    lazy var facebookConfig     = FacebookConfiguration()

    public lazy var appConfiguration = AppConfiguration(
        firebase: firebaseConfig,
        revenueCat: revenueCatConfig,
        notification: notificationConfig,
        facebook: facebookConfig
    )

    public lazy var appRouterSDKConfiguration = AppRouterSDKConfiguration(
        google: googleConfig,
        facebook: facebookConfig
    )
}
