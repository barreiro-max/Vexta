//
//  UIKitTopViewControllerProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import Foundation
import UIKit

public struct UIKitTopViewControllerProvider: TopViewControllerProvider {
    public init() {}
    
    @MainActor public func getTopViewController(from base: UIViewController? = nil) -> UIViewController? {

        let rootVC: UIViewController?
        if let base {
            rootVC = base
        } else {
            let activeScene = UIApplication.shared.connectedScenes.first {
                $0.activationState == .foregroundActive
            } as? UIWindowScene

            rootVC = activeScene?.windows.first { $0.isKeyWindow }?.rootViewController
        }

        if let navigation = rootVC as? UINavigationController {
            return getTopViewController(from: navigation.visibleViewController)
        }

        if let tab = rootVC as? UITabBarController {
            return getTopViewController(from: tab.selectedViewController)
        }

        if let presented = rootVC?.presentedViewController {
            return getTopViewController(from: presented)
        }

        return rootVC
    }
}
