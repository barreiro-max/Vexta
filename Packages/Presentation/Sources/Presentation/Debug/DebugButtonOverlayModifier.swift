//
//  DebugButtonOverlayModifier.swift
//  Vexta
//
//  Created by MaxAdmin on 15.09.2026.
//

import SwiftUI
import Environment

#if DEBUG
public struct DebugButtonOverlayModifier<Route: Equatable, Sheet>: ViewModifier {
    @Binding private var rootRoute: Route
    @Binding private var rootSheet: Sheet?
    private let debugRoute: Route

    public init(
        rootRoute: Binding<Route>,
        rootSheet: Binding<Sheet?>,
        debugRoute: Route
    ) {
        self._rootRoute = rootRoute
        self._rootSheet = rootSheet
        self.debugRoute = debugRoute
    }

    public func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content

            if EnvironmentVariables.isUseDebugView && rootRoute != debugRoute {
                Button("Debug") {
                    rootSheet = nil
                    rootRoute = debugRoute
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 50)
                .padding(.trailing, 16)
                .zIndex(999)
            }
        }
    }
}

extension View {
    public func debugButtonOverlay<Route: Equatable, Sheet>(
        rootRoute: Binding<Route>,
        rootSheet: Binding<Sheet?>,
        debugRoute: Route
    ) -> some View {
        modifier(
            DebugButtonOverlayModifier(
                rootRoute: rootRoute,
                rootSheet: rootSheet,
                debugRoute: debugRoute
            )
        )
    }
}
#else
extension View {
    @inline(__always)
    public func debugButtonOverlay<Route, Sheet>(
        rootRoute: Any,
        rootSheet: Any,
        debugRoute: Route
    ) -> some View { self }
}
#endif
