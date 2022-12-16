//
//  ViewController.swift
//  Convenientimer
//
//  Created by justin on 12.12.2022.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func viewDidLoad()
    func didUpdate(time: Time)
    func didTapLeftButton()
    func didTapRightButton()
    func didSelectHistory(at index: Int)
}

protocol ViewControllerDataSource: AnyObject {
    var historySize: Int { get }
    func entry(at index: Int) -> Time
}

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var circlesContainer: UIView!

    @IBOutlet private weak var hourCircle: CircleView!
    @IBOutlet private weak var minuteCircle: CircleView!
    @IBOutlet private weak var secondCircle: CircleView!

    @IBOutlet private weak var timeLabel: UILabel!

    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    weak var delegate: ViewControllerDelegate?
    weak var datasource: ViewControllerDataSource?

    var presenter: Any?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate?.viewDidLoad()

        [
            hourCircle,
            minuteCircle,
            secondCircle,
        ].forEach {
            $0.delegate = self
        }

        tableView.register(UINib(nibName: String(describing: TableCell.self), bundle: nil), forCellReuseIdentifier: TableCell.identifier)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        [
//            hourCircle,
//            minuteCircle,
//            secondCircle,
//        ].forEach {
//            $0.relayout()
//        }
    }

    func set(time: Time) {
        timeLabel.text = time.asString()

        hourCircle.set(value: CGFloat(time.hours) / 12)
        minuteCircle.set(value: CGFloat(time.minutes) / 59)
        secondCircle.set(value: CGFloat(time.seconds) / 59)
    }
    
    func set(viewState state: ViewModel) {
        leftButton.isEnabled = state.isLeftButtonEnabled

        rightButton.isEnabled = state.isRightButtonEnabled
        rightButton.setTitle(state.rightButtonText, for: .normal)
        rightButton.setTitleColor(state.rightButtonColor, for: .normal)

        circlesContainer.isUserInteractionEnabled = state.isSliderEnabled
    }

    func reload() {
        tableView.reloadData()
    }

    @IBAction private func didTapLeftButton() {
        delegate?.didTapLeftButton()
    }
    
    @IBAction private func didTapRightButton() {
        delegate?.didTapRightButton()
    }
}

extension ViewController: CircleViewDelegate {
    func didChangeValue() {
        delegate?.didUpdate(time: Time(
                hours: Int(round(hourCircle.value * 12)),
                minutes: Int(round(minuteCircle.value * 59)),
                seconds: Int(round(secondCircle.value * 59))
        ))
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.historySize ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath)

        if let tableCell = cell as? TableCell,
           let viewModel = datasource?.entry(at: indexPath.row) {
            tableCell.configure(viewModel: viewModel)
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectHistory(at: indexPath.row)
    }
}

