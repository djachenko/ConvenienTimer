//
// Created by justin on 14.12.2022.
//

import Foundation
import AVFoundation
import UIKit

class AlertService {
    func alert(vc: UIViewController, completion: @escaping () -> Void = {}) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)

        let alert = UIAlertController(title: "Alert", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion() })

        vc.present(alert, animated: true)
    }
}
