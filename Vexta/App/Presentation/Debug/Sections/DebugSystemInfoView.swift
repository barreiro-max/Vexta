//
//  DebugSystemInfoView.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

#if DEBUG
import SwiftUI

struct DebugSystemInfoView: View {

    let environment: String

    var body: some View {
        NavigationStack {
            List {
                Section("App & Device Info") {
                    LabeledContent("Bundle ID", value: Bundle.main.bundleIdentifier!)
                    LabeledContent("iOS Version", value: UIDevice.current.systemVersion)
                    LabeledContent("Device", value: UIDevice.current.model)
                    LabeledContent("Environment", value: environment)

                    SystemCopyButton(copyAction: copyToClipboard)
                }
            }
            .navigationTitle("System Info")
            .textSelection(.enabled)
        }
    }

    private func copyToClipboard() {
        UIPasteboard.general.string = """
        Bundle ID: \(Bundle.main.bundleIdentifier ?? "N/A")
        iOS: \(UIDevice.current.systemVersion)
        Device: \(UIDevice.current.model)
        """
    }
}
#endif
