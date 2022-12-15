//
// Created by justin on 15.12.2022.
//

import Foundation
import UIKit

struct ViewModel {
    let isLeftButtonEnabled: Bool
    let isRightButtonEnabled: Bool
    let rightButtonText: String
    let rightButtonColor: UIColor
    let isSliderEnabled: Bool

    private init(
            isLeftButtonEnabled: Bool,
            isRightButtonEnabled: Bool = true,
            rightButtonText: String,
            rightButtonColor: UIColor,
            isSliderEnabled: Bool = true
    ) {
        self.isLeftButtonEnabled = isLeftButtonEnabled
        self.isRightButtonEnabled = isRightButtonEnabled
        self.rightButtonText = rightButtonText
        self.rightButtonColor = rightButtonColor
        self.isSliderEnabled = isSliderEnabled
    }

    static let disabled: ViewModel = .init(
            isLeftButtonEnabled: false,
            isRightButtonEnabled: false,
            rightButtonText: "Start",
            rightButtonColor: .green
    )

    static let stopped: ViewModel = .init(
            isLeftButtonEnabled: false,
            rightButtonText: "Start",
            rightButtonColor: .green
    )

    static let ticking: ViewModel = .init(
            isLeftButtonEnabled: true,
            rightButtonText: "Pause",
            rightButtonColor: .yellow,
            isSliderEnabled: false
    )

    static let paused: ViewModel = .init(
            isLeftButtonEnabled: true,
            rightButtonText: "Continue",
            rightButtonColor: .green,
            isSliderEnabled: false
    )
}