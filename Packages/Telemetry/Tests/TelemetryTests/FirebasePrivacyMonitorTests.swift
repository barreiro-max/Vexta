//
//  FirebasePrivacyMonitorTests.swift
//  Vexta
//
//  Created by MaxAdmin on 04.07.2026.
//

import Foundation
import Testing
@testable import Telemetry

@Suite(.tags(.telemetry))
struct FirebasePrivacyMonitorTests {

    private let factory = UserDefaultsFactory()

    @Test func collectData_true_isCollectionData_expectEnabled() {
        let mockDefaults = factory.makeUserDefaults(suiteName: #function)
        let sut = FirebasePrivacyMonitor(defaults: mockDefaults)

        sut.telemetryCollection(isEnabled: true)

        #expect(sut.isTelemetryEnabled == true)
        #expect(sut.needsGDPRConsent == false)
    }

    @Test func collectData_false_isCollectionData_expectDisabled() {
        let mockDefaults = factory.makeUserDefaults(suiteName: #function)
        let sut = FirebasePrivacyMonitor(defaults: mockDefaults)

        sut.telemetryCollection(isEnabled: false)

        #expect(sut.isTelemetryEnabled == false)
        #expect(sut.needsGDPRConsent == false)
    }

    @Test func isCollectionData_initial_expectDisabled() {
        let mockDefaults = factory.makeUserDefaults(suiteName: #function)
        let sut = FirebasePrivacyMonitor(defaults: mockDefaults)

        #expect(sut.isTelemetryEnabled == false)
        #expect(sut.needsGDPRConsent == true)
    }
}
