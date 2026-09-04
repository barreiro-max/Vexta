//
//  ReminderContent.swift
//  Vexta
//
//  Created by MaxAdmin on 31.08.2026.
//

import Foundation

public struct ReminderContent: Identifiable, Hashable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let body: String
    public let isRepeats: Bool
    public let type: ReminderType
    public let attachmentURL: URL?
    public let attachmentIdentifier: String?

    public init(
        id: String,
        title: String,
        subtitle: String,
        body: String,
        isRepeats: Bool = false,
        type: ReminderType,
        attachmentURL: URL? = nil,
        attachmentIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.isRepeats = isRepeats
        self.type = type
        self.attachmentURL = attachmentURL
        self.attachmentIdentifier = attachmentIdentifier
    }
}


