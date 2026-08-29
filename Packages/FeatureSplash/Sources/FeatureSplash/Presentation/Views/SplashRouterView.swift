//
//  SplashStateView.swift
//  Vexta
//
//  Created by MaxAdmin on 31.07.2026.
//

import SwiftUI

struct SplashRouterView: View {

    private(set) var state: SplashStoreState

    var body: some View {
        switch state {
        case .idle:
            idleView

        case .loading(let message?):
            loadingView(with: message)

        case .loading(nil):
            loadingView(with: "Loading...")

        case .failure(let error):
            failureView(error.localizedDescription)

        case .completed:
            completedView
        }
    }

    private var idleView: some View {
        Text("Idle View")
    }

    private func loadingView(with message: String) -> some View {
        VStack {
            ProgressView()
            Text(message)
        }
    }

    private func failureView(_ message: String) -> some View {
        Text("Failure view: \(message)")
            .foregroundStyle(.red)
    }

    private var completedView: some View {
        Text("Completed Bootstrap")
            .foregroundStyle(.green)
            .bold()
    }
}

#Preview {
    SplashRouterView(state: .idle)
}

#Preview {
    SplashRouterView(state: .loading(message: "Preview loading message..."))
}

#Preview {
    SplashRouterView(state: .loading(message: nil))
}

#Preview {
    SplashRouterView(state: .failure(error: .noInternetConnection))
}

#Preview {
    SplashRouterView(state: .completed)
}
