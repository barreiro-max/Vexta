//
//  FinishOnboardingView.swift
//  Vexta
//
//  Created by MaxAdmin on 29.08.2026.
//

import SwiftUI
import Domain

struct FinishOnboardingView: View {

    @State private var store: FinishOnboardingStore

    init(store: FinishOnboardingStore) {
        self.store = store
    }

    var body: some View {
        Button("Finish") {
            store.send(.finished)
        }
    }
}

#Preview {
    let completeOnboardingUseCase = PreviewCompleteOnboardingUseCase()
    let store = FinishOnboardingStore(completeOnboardingUseCase: completeOnboardingUseCase) { _ in}
    FinishOnboardingView(store: store)
}
