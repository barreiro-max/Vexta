//
//  DebugEnvironmentView.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

#if DEBUG
import SwiftUI
import Environment

struct DebugEnvironmentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Environment Variables") {
                    boolRow("Use Debug View", isOn: BuildConfiguration.isUseDebugView)
                    boolRow("Test Configuration", isOn: BuildConfiguration.isTestConfiguration)
                    boolRow("Use Firebase Emulator", isOn: BuildConfiguration.isUseFirebaseEmulator)
                    boolRow("User is Premium", isOn: BuildConfiguration.isUserPremium)
                }

                Section("Info Plist") {
                    LabeledContent("RevenueCat API Key", value: BuildConfiguration.revenueCatAPIKey)
                    LabeledContent("FakeStore API URL", value: BuildConfiguration.fakeStoreAPIURL.absoluteString)
                    boolRow("Analytics Collection", isOn: BuildConfiguration.isAnalyticsCollectionEnabled)
                }
            }
            .navigationTitle("Environment")
            .textSelection(.enabled)
        }
    }

    @ViewBuilder
    private func boolRow(_ title: String, isOn: Bool) -> some View {
        LabeledContent(title) {
            HStack(spacing: 4) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "xmark.circle")
                    .foregroundColor(isOn ? .green : .secondary)
                Text(isOn ? "YES" : "NO")
                    .bold()
            }
        }
    }
}
#endif
