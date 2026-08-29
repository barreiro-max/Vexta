//
//  AppDelegate.swift
//  Vexta
//
//  Created by MaxAdmin on 17.07.2026.
//

import UIKit
import Configuration

final class AppDelegate: NSObject, UIApplicationDelegate {

    var configContainer: ConfigContainer!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        guard let configContainer else {
            preconditionFailure("ConfigContainer WAS NOT SET IN VextaApp.init")
        }

        let appConfig = configContainer.appConfiguration

        appConfig.configureApp(
            application, didFinishLaunchingWithOptions: launchOptions
        )

        return true
    }
}
