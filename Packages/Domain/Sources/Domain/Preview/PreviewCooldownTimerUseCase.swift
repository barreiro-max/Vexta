//
//  PreviewCooldownTimerUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.08.2026.
//

import Foundation

public struct PreviewCooldownTimerUseCase: CooldownTimerUseCase {
    public init() {}

    public func execute(from seconds: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            let task = Task {
                continuation.yield(5)
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(4)
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(3)
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(2)
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(1)
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(0)

                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
