//
//  CooldownTimerUseCase.swift
//  Vexta
//
//  Created by MaxAdmin on 30.08.2026.
//

import Foundation

public protocol CooldownTimerUseCase: Sendable {
    func execute(from seconds: Int) -> AsyncStream<Int>
}

public struct CooldownTimerUseCaseImpl {
    public init() {}
}

extension CooldownTimerUseCaseImpl: CooldownTimerUseCase {
    public func execute(from seconds: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            let task = Task {
                var cooldown = seconds
                continuation.yield(cooldown)

                while cooldown > 0 {
                    try? await Task.sleep(for: .seconds(1))
                    if Task.isCancelled { break }

                    cooldown -= 1
                    continuation.yield(cooldown)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
