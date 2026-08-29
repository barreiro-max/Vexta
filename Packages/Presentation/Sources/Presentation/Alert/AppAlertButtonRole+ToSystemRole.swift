//
//  AppAlertButtonRole+ToSystemRole.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import SwiftUI

extension AppAlertButtonRole {
    public var toSystemRole: ButtonRole? {
        switch self {
        case .cancel, .close:
            .cancel
        case .destructive:
            .destructive
        default:
            nil
        }
    }
}
