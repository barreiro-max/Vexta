//
//  AppDelegate.swift
//  Vexta
//
//  Created by MaxAdmin on 17.07.2026.
//

import UIKit
import Configuration
import Notification

final class AppDelegate: NSObject, UIApplicationDelegate {

    var configContainer: ConfigContainer!
    var notificationContainer: NotificationContainer!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        guardPreconditionFailure()
        configureUserNotification()
        configureAppConfiguration(application, launchOptions)
        return true
    }

    private func guardPreconditionFailure() {
        guard let _ = configContainer else {
            preconditionFailure("ConfigContainer WAS NOT SET IN VextaApp.init")
        }

        guard let _ = notificationContainer else {
            preconditionFailure("NotificationContainer WAS NOT SET IN VextaApp.init")
        }
    }

    private func configureUserNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationContainer.notificationDelegate

        Task { try await center.setBadgeCount(0) }
    }

    private func configureAppConfiguration(
        _ application: UIApplication,
        _ launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) {
        let appConfig = configContainer.appConfiguration

        appConfig.configureApp(
            application, didFinishLaunchingWithOptions: launchOptions
        )
    }
}
