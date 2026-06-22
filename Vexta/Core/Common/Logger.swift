//
//  Logger.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!

    static let auth     = Logger(subsystem: subsystem, category: "🔐 Auth")
    static let catalog  = Logger(subsystem: subsystem, category: "📚 Catalog")
    static let cart     = Logger(subsystem: subsystem, category: "🛒 Cart")
    static let checkout = Logger(subsystem: subsystem, category: "💳 Checkout")
    static let orders   = Logger(subsystem: subsystem, category: "📦 Orders")
    static let network  = Logger(subsystem: subsystem, category: "🌐 Network")
    static let purchase = Logger(subsystem: subsystem, category: "💰 Purchase")
    static let storage  = Logger(subsystem: subsystem, category: "💾 Storage")
}

