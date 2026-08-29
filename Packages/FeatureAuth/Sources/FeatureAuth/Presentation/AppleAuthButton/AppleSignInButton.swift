//
//  AppleSignInButton.swift
//  Vexta
//
//  Created by MaxAdmin on 05.07.2026.
//

import SwiftUI

struct AppleSignInButton: View {
    private let signInAction: () -> Void

    init(signInAction: @escaping () -> Void) {
        self.signInAction = signInAction
    }

    var body: some View {
        Button(action: signInAction) {
            representableLabel
        }
        .frame(maxHeight: 55)
        .padding()
    }

    private var representableLabel: some View {
        AppleAuthButtonViewRepresentable(
            buttonType: .signIn,
            cornerRadius: 32
        )
        .allowsHitTesting(false)
    }
}
