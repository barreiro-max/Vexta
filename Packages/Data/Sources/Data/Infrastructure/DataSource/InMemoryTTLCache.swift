import Foundation
import Synchronization
import Domain

final class InMemoryTTLCache<Value: Identifiable & Sendable>: InMemoryCache where Value.ID: Sendable {

    private struct CacheEntry: Identifiable, Sendable {
        let id: Value.ID
        let value: Value
        let createdAt: Date = .now
    }

    private let storage = Mutex<[CacheEntry.ID: CacheEntry]>([:])
    private let TTL: TimeInterval

    init(TTL: TimeInterval = 600) {
        self.TTL = TTL
    }

    var isEmpty: Bool {
        storage.withLock { $0.isEmpty }
    }

    func get(for key: Value.ID) -> Value? {
        storage.withLock { dict in
            guard let cachedEntry = dict[key] else { return nil }

            let isValid = Date().timeIntervalSince(cachedEntry.createdAt) < TTL

            guard isValid else {
                dict.removeValue(forKey: key)
                return nil
            }

            return cachedEntry.value
        }
    }

    func getAll() -> [Value]? {
        storage.withLock { dict in
            let now = Date.now
            let initialCount = dict.count

            dict = dict.filter { _, entry in
                now.timeIntervalSince(entry.createdAt) < TTL
            }

            guard dict.count == initialCount else { return nil }

            let values = dict.values.map(\.value)
            return values.isEmpty ? nil : values
        }
    }

    func set(_ value: Value) {
        storage.withLock { dict in
            dict[value.id] = CacheEntry(id: value.id, value: value)
        }
    }

    func setAll(_ values: [Value]) {
        storage.withLock { dict in
            for value in values {
                dict[value.id] = CacheEntry(id: value.id, value: value)
            }
        }
    }

    func remove(for key: Value.ID) {
        storage.withLock { dict in
            _ = dict.removeValue(forKey: key)
        }
    }
}
