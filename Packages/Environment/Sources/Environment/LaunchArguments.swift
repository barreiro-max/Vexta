//
//  LaunchArguments.swift
//  Vexta
//
//  Created by MaxAdmin on 19.07.2026.
//

import Foundation

public enum LaunchArguments {
    public static var firebaseDebugEnabled:      Bool { ArgumentKey.firDebugEnabled.isActive }
    public static var firebaseDebugDisabled:     Bool { ArgumentKey.firDebugDisabled.isActive }
    public static var firebaseAnalyticsEnabled:  Bool { ArgumentKey.firAnalyticsEnabled.isActive }
    public static var firebaseAnalyticsDisabled: Bool { ArgumentKey.firAnalyticsDisabled.isActive }
}

fileprivate enum ArgumentKey: String {
    case firDebugEnabled      = "-FIRDebugEnabled"
    case firDebugDisabled     = "-FIRDebugDisabled"

    case firAnalyticsEnabled  = "-FIRAnalyticsEnabled"
    case firAnalyticsDisabled = "-FIRAnalyticsDisabled"

    private var key: String { self.rawValue }

    var isActive: Bool {
        ProcessInfo.processInfo.arguments.contains(key)
    }
}
