//
//  SceneDelegate.swift
//  Vexta
//
//  Created by MaxAdmin on 29.07.2026.
//

import UIKit
import Configuration

final class SceneDelegate: NSObject, UISceneDelegate {

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let appDelegateConfigContainer else {
            return
        }

        let appRouterSDKConfig = appDelegateConfigContainer.appRouterSDKConfiguration

        appRouterSDKConfig.configureRoutingSDKs(
            openURLContexts: URLContexts
        )
    }

    private var appDelegateConfigContainer: ConfigContainer? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("ConfigContainer WAS NOT SET IN AppDelegate")
        }
        return appDelegate.configContainer
    }
}
