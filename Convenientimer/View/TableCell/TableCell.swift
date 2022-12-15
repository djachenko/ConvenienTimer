//
// Created by justin on 15.12.2022.
//

import Foundation
import UIKit

typealias CellViewModel = Time

class TableCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!

    func configure(viewModel: CellViewModel) {
        label.text = viewModel.asString()
    }
}

extension UITableViewCell {
    class var identifier: String {
        return String(describing: Self.self)
    }
}
