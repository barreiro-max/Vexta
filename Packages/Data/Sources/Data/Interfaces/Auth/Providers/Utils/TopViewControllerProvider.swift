//
//  TopViewControllerProvider.swift
//  Vexta
//
//  Created by MaxAdmin on 02.08.2026.
//

import UIKit

public protocol TopViewControllerProvider: Sendable {
    @MainActor func getTopViewController(from base: UIViewController?) -> UIViewController?
}

extension TopViewControllerProvider {
    @MainActor
    public func getTopViewController(from base: UIViewController? = nil) -> UIViewController? {
        self.getTopViewController(from: base)
    }
}
