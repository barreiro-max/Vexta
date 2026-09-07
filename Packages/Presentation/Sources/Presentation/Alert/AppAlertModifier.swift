//
//  AppAlertModifier.swift
//  Vexta
//
//  Created by MaxAdmin on 09.08.2026.
//

import SwiftUI
import Foundation

public struct AppAlertModifier: ViewModifier {

    @Binding private var alert: AppAlert?

    public init(alert: Binding<AppAlert?>) {
        self._alert = alert
    }

    public func body(content: Content) -> some View {
        content
            .alert(
                alert?.error.errorDescription ?? "Unknown error",
                isPresented: isPresentedAlertBinding,
                presenting: alert
            ) { currentAlert in
                ForEach(currentAlert.buttonActions) { buttonAction in
                    alertButton(buttonAction)
                }
            }
    }

    private var isPresentedAlertBinding: Binding<Bool> {
        Binding(
            get: { alert != nil },
            set: { if !$0 { alert = nil } }
        )
    }

    private func alertButton(_ buttonAction: AppAlertButtonAction) -> some View {
        Button(
            buttonAction.buttonTitle,
            role: buttonAction.buttonRole.toSystemRole
        ) {
            Task { await buttonAction.action?() }
        }
    }
}

public extension View {
    func handleAppAlert(_ alert: Binding<AppAlert?>) -> some View {
        self.modifier(AppAlertModifier(alert: alert))
    }
}
