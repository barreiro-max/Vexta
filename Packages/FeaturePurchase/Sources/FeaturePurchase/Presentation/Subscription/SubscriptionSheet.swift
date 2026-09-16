//
//  SubscriptionSheet.swift
//  Vexta
//
//  Created by MaxAdmin on 12.09.2026.
//

import SwiftUI
import RevenueCatUI

public struct SubscriptionSheet: View {

    @State private var sheetStore: SubscriptionSheetStore
    @Environment(\.dismiss) var dismiss

    public init(sheetStore: SubscriptionSheetStore) {
        _sheetStore = State(wrappedValue: sheetStore)
    }

    public var body: some View {
        Group {
            switch sheetStore.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            case .neededPaywall: PaywallView(displayCloseButton: true)

            case .hasPremium: Color.clear.onAppear { dismiss() }

            case .failure(let error): Text("Error: \(error.localizedDescription)")
            }
        }
        .onAppear {
            sheetStore.send(.checkUserPremiumStatus)
        }
    }
}

#Preview {
    let checkUserPremiumStatusUseCase = PreviewCheckUserPremiumStatusUseCase()
    let sheetStore = SubscriptionSheetStore(
        checkUserPremiumStatusUseCase: checkUserPremiumStatusUseCase,
        onStoreSheetEvent: {_ in}
    )
    SubscriptionSheet(sheetStore: sheetStore)
}
