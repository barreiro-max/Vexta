//
//  CrashlyticsRecorder.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import Foundation

public protocol CrashlyticsRecorder {
    func set(userId id: String?)
    func set(value: String?, key: String)
    func set(crashRecordDictionary: CrashRecordDictionary)
    func log(message: String)
    func record(error: any Error, crashRecordInfo: CrashRecordUserInfo)
}
