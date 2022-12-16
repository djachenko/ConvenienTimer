//
// Created by justin on 15.12.2022.
//

import Foundation

typealias History = [Time]

class HistoryService {
    private static let key = "TimerHistory"
    private static let size = 10

    private var defaults: UserDefaults {
        return UserDefaults.standard
    }

    private var cachedHistory: History?

    var history: History {
        cachedHistory = cachedHistory ?? read()

        return cachedHistory!
    }

    func add(entry: Time) {
        let existingEntries = history

        var updated_entries = [entry] + existingEntries.filter { $0 != entry }

        updated_entries = Array(updated_entries.prefix(HistoryService.size))

        cachedHistory = updated_entries

        write(entries: updated_entries)
    }

    private func read() -> History {
        if let data = defaults.object(forKey: HistoryService.key) as? Data,
           let history = try? JSONDecoder().decode(History.self, from: data) {
            return history
        }

        return []
    }

    private func write(entries: History) {
        if let encoded = try? JSONEncoder().encode(entries) {
            defaults.set(encoded, forKey: HistoryService.key)
        }
    }
}
