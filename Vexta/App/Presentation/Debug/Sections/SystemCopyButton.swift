//
//  SystemCopyButton.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//
#if DEBUG
import SwiftUI

struct SystemCopyButton: View {

    let copyAction: () -> Void
    @State private var isCopied = false

    var body: some View {
        Button {
            copyAction()
            isCopied = true
        } label: {
            Label(
                isCopied ? "Copied" : "Copy Info",
                systemImage: isCopied ? "checkmark" : "doc.on.doc"
            )
            .contentTransition(.symbolEffect(.replace))
        }
        .sensoryFeedback(.success, trigger: isCopied)
        .task(id: isCopied) {
            if isCopied {
                try? await Task.sleep(for: .seconds(1.5))
                isCopied = false
            }
        }
    }
}
#endif
