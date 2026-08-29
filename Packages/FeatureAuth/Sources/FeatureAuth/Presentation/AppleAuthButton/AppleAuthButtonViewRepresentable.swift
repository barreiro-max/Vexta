//
//  AppleAuthButtonViewRepresentable.swift
//  Vexta
//
//  Created by MaxAdmin on 22.08.2026.
//

import SwiftUI
import AuthenticationServices

struct AppleAuthButtonViewRepresentable: UIViewRepresentable {
    @Environment(\.colorScheme) private var colorScheme

    private let buttonType: UIViewType.ButtonType
    private let cornerRadius: CGFloat

    public init(
        buttonType: UIViewType.ButtonType,
        cornerRadius: CGFloat
    ) {
        self.buttonType = buttonType
        self.cornerRadius = cornerRadius
    }

    func makeUIView(context: Context) -> UIViewType {
        let appleSignInButton = ASAuthorizationAppleIDButton(
            authorizationButtonType: buttonType,
            authorizationButtonStyle: colorScheme == .light ? .black : .white
        )
        appleSignInButton.cornerRadius = cornerRadius
        return appleSignInButton

    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}

    typealias UIViewType = ASAuthorizationAppleIDButton
}
