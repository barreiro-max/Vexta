//
//  FirebaseCrashlyticsRecorder.swift
//  Vexta
//
//  Created by MaxAdmin on 02.07.2026.
//

import Foundation
import FirebaseCrashlytics
import Domain

public struct FirebaseCrashlyticsRecorder {

    private var crashlyticsShared: Crashlytics {
        Crashlytics.crashlytics()
    }
}

extension FirebaseCrashlyticsRecorder: CrashlyticsRecorder {
    public func set(userId id: String?) {
        crashlyticsShared.setUserID(id)
    }

    public func set(value: String?, key: String) {
        crashlyticsShared.setCustomValue(value, forKey: key)
    }

    public func set(crashRecordDictionary: CrashRecordDictionary) {
        crashlyticsShared.setCustomKeysAndValues(
            crashRecordDictionary.keysAndValues
        )
    }

    public func log(message: String) {
        crashlyticsShared.log(message)
    }

    public func record(error: any Error, crashRecordInfo: CrashRecordUserInfo) {
        crashlyticsShared.record(
            error: error as NSError,
            userInfo: crashRecordInfo.userInfo
        )
    }
}
