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
        let history = cachedHistory ?? read()
        cachedHistory = history

        return history
    }

    private func read() -> History {
        if let data = defaults.object(forKey: HistoryService.key) as? Data,
           let history = try? JSONDecoder().decode(History.self, from: data) {
            return history
        }

        return []
    }

    func add(entry: Time) {
        let existingEntries = history

        var new_entries = [entry] + existingEntries.filter { $0 != entry }

        new_entries = Array(new_entries.prefix(HistoryService.size))

        cachedHistory = new_entries

        if let encoded = try? JSONEncoder().encode(new_entries) {
            defaults.set(encoded, forKey: HistoryService.key)
        }
    }
}
