//
//  Log.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import Foundation
@_exported import OSLog

public enum Log {
    fileprivate static let subsystem = Bundle.main.bundleIdentifier!

    public static let auth         = LogCategory.auth.logger
    public static let network      = LogCategory.network.logger
    public static let purchase     = LogCategory.purchase.logger
    public static let storage      = LogCategory.storage.logger
    public static let system       = LogCategory.system.logger
    public static let remoteConfig = LogCategory.remoteConfig.logger
    public static let notification = LogCategory.notification.logger
    public static let useCase      = LogCategory.useCase.logger
    public static let store        = LogCategory.store.logger
    public static let ui           = LogCategory.ui.logger

#if DEBUG
    public static let mockNetwork  = LogCategory.mockNetwork.logger
    public static let mockAuth     = LogCategory.mockAuth.logger
#endif
}

fileprivate enum LogCategory: String {
    case auth           = "🔐 Auth"
    case network        = "🌐 Network"
    case purchase       = "💰 Purchase"
    case storage        = "💾 Storage"
    case system         = "⚙️ System"
    case remoteConfig   = "🖥️ Remote Config"
    case notification   = "🔔 Notification"
    case useCase        = "👨‍💼 Use Case"
    case store          = "👨‍🍳 Store"
    case ui             = "🎨 UI"

#if DEBUG
    case mockNetwork    = "🛠️🌐 Mock Network"
    case mockAuth       = "🛠️🔐 Mock Auth"
#endif

    private var category: String { self.rawValue }

    var logger: Logger {
        Logger(subsystem: Log.subsystem, category: category)
    }
}
