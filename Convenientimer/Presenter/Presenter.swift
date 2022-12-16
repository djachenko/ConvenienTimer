//
// Created by justin on 14.12.2022.
//

import Foundation



class Presenter {
    private enum State {
        case stopped
        case ticking
        case paused
    }

    private var time: Time = Time(hours: 0, minutes: 1, seconds: 0) {
        didSet {
            updateViewState()
        }
    }

    private var timer: Timer?

    private var state: State = .stopped {
        didSet {
            updateViewState()
        }
    }

    private func updateViewState() {
        let viewState: ViewModel

        switch state {
        case .stopped:
            if time != .zero {
                viewState = .stopped
            } else {
                viewState = .disabled
            }
        case .ticking:
            viewState = .ticking
        case .paused:
            viewState = .paused
        }

        view.set(viewState: viewState)
    }

    private weak var view: ViewController!

    private let alertService: AlertService
    private let historyService: HistoryService

    init(
            view: ViewController,
            alertService: AlertService,
            historyService: HistoryService
    ) {
        self.view = view
        self.alertService = alertService
        self.historyService = historyService

        view.delegate = self
        view.datasource = self
    }

    private func start() {

        let totalSeconds = time.totalSeconds()
        var elapsedSeconds = 0

        timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self,
                  self.state == .ticking else {
                return
            }

            elapsedSeconds += 1

            let remainingSeconds = totalSeconds - elapsedSeconds
            let currentTime = Time(seconds: remainingSeconds)

            self.view.set(time: currentTime)

            if remainingSeconds == 0 {
                self.stop()

                self.alertService.alert(vc: self.view) { [weak self] in
                    self?.reset()
                }
            }
        }

        historyService.add(entry: time)

        view.reloadHistory()

        state = .ticking
    }

    private func stop() {
        timer?.invalidate()

        state = .stopped
    }

    private func reset() {
        view.set(time: time)
    }
}

extension Presenter: ViewControllerDelegate {
    func viewDidLoad() {
        view.set(viewState: .stopped)
        view.set(time: time)
    }

    func didUpdate(time: Time) {
        self.time = time

        view.set(time: time)
    }

    func didTapLeftButton() {
        stop()
        reset()
    }

    func didTapRightButton() {
        switch state {

        case .stopped:
            start()
        case .ticking:
            state = .paused
        case .paused:
            state = .ticking
        }
    }

    func didSelectHistory(at index: Int) {
        didUpdate(time: historyService.history[index])
    }
}

extension Presenter: ViewControllerDataSource {
    var historySize: Int {
        return historyService.history.count
    }

    func entry(at index: Int) -> Time {
        return historyService.history[index]
    }
}