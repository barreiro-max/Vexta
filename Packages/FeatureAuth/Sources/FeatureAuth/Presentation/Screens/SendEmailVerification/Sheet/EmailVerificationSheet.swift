//
//  EmailVerificationSheet.swift
//  Vexta
//
//  Created by MaxAdmin on 10.09.2026.
//

import SwiftUI

public struct EmailVerificationSheet: View {

    public init() {}

    public var body: some View {
        ContentUnavailableView(
            "Email Not Verified",
            systemImage: "envelope.badge.shield.half.filled",
            description: Text("Please check your inbox and verify your email address to continue.")
        )
        .presentationDetents([.medium])
    }
}

#Preview {
    EmailVerificationSheet()
}
