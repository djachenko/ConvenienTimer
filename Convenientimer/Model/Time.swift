//
// Created by justin on 14.12.2022.
//

import Foundation

struct Time {
    let hours: Int
    let minutes: Int
    let seconds: Int

    init(
            hours: Int,
            minutes: Int,
            seconds: Int
    ) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }

    init(seconds: Int) {
        self.init(
                hours: Int(seconds / 3600),
                minutes: Int(seconds % 3600 / 60),
                seconds: seconds % 60
        )
    }

    static let zero = Time(hours: 0, minutes: 0, seconds: 0)

    func totalSeconds() -> Int {
        return seconds + (minutes + hours * 60) * 60
    }

    func asString() -> String {
        return String(
                format: "%d:%02d:%02d",
                hours,
                minutes,
                seconds
        )
    }
}

extension Time: Equatable {}

extension Time: Codable {}
