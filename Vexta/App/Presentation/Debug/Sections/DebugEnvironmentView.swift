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
                    boolRow("Use Debug View", isOn: EnvironmentVariables.isUseDebugView)
                    boolRow("Test Configuration", isOn: EnvironmentVariables.isTestConfiguration)
                    boolRow("Use Firebase Emulator", isOn: EnvironmentVariables.isUseFirebaseEmulator)
                    boolRow("User is Premium", isOn: EnvironmentVariables.isUserPremium)
                }

                Section("Info Plist") {
                    LabeledContent("RevenueCat API Key", value: InfoPlistConfiguration.revenueCatAPIKey)
                    LabeledContent("FakeStore API URL", value: InfoPlistConfiguration.fakeStoreAPIURL.absoluteString)
                    boolRow("Analytics Collection", isOn: InfoPlistConfiguration.isAnalyticsCollectionEnabled)
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
