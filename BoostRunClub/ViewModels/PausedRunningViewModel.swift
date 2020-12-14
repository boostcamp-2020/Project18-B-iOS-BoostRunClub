//
//  PausedRunningViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
import CoreLocation
import Foundation

protocol PausedRunningViewModelTypes {
    var inputs: PausedRunningViewModelInputs { get }
    var outputs: PausedRunningViewModelOutputs { get }
}

protocol PausedRunningViewModelInputs {
    func didTapResumeButton()
    func didLongHoldStopRunningButton()
    func viewDidAppear()
    func closeAnimationEnded()
    func didTapRunData(index: Int)
}

protocol PausedRunningViewModelOutputs {
    var showRunningInfoSignal: PassthroughSubject<Void, Never> { get }
    var showRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var closeRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var runningInfoTapAnimationSignal: PassthroughSubject<Int, Never> { get }
    var showPrepareRunningSignal: PassthroughSubject<Void, Never> { get }
    var runInfoData: [RunningInfo] { get }
    var pathCoordinates: [CLLocationCoordinate2D] { get }
    var slices: [RunningSlice] { get }
}

class PausedRunningViewModel: PausedRunningViewModelInputs, PausedRunningViewModelOutputs {
    let runningDataProvider: RunningDataServiceable
    private var cancellables = Set<AnyCancellable>()

    // TODO: RunningDataProvicer Protocol 구현
    init(runningDataProvider: RunningDataServiceable) {
        self.runningDataProvider = runningDataProvider
        let avgPace = runningDataProvider.avgPace.value
        let pace = runningDataProvider.pace.value
        let cadence = runningDataProvider.cadence.value
        let calorie = runningDataProvider.calorie.value
        pathCoordinates = runningDataProvider.locations.map { $0.coordinate }
        runInfoData = [
            RunningInfo(type: .time, value: runningDataProvider.runningTime.value.simpleFormattedString),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", avgPace / 60, avgPace % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", pace / 60, pace % 60)),
            RunningInfo(type: .kilometer, value: String(format: "%.2f", runningDataProvider.distance.value / 1000)),
            RunningInfo(type: .calorie, value: calorie <= 0 ? "--" : String(calorie)),
            RunningInfo(type: .cadence, value: cadence <= 0 ? "--" : String(cadence)),
        ]

        runningDataProvider.currentMotionType
            .throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: true)
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] motion in
                if motion.running || motion.walking, motion.confidence == .high {
                    self?.didTapResumeButton()
                }
            }.store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs
    func didTapResumeButton() {
        closeRunningInfoAnimationSignal.send()
        runningDataProvider.resume()
    }

    func didLongHoldStopRunningButton() {
        runningDataProvider.stop()
        showPrepareRunningSignal.send()
    }

    func viewDidAppear() {
        showRunningInfoAnimationSignal.send()
    }

    func closeAnimationEnded() {
        showRunningInfoSignal.send()
    }

    func didTapRunData(index: Int) {
        runningInfoTapAnimationSignal.send(index)
    }

    // Outputs

    var runInfoData: [RunningInfo]
    var pathCoordinates: [CLLocationCoordinate2D]

    var slices: [RunningSlice] {
        runningDataProvider.routes
    }

    var showRunningInfoSignal = PassthroughSubject<Void, Never>()
    var showRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var closeRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var runningInfoTapAnimationSignal = PassthroughSubject<Int, Never>()
    var showPrepareRunningSignal = PassthroughSubject<Void, Never>()
}

extension PausedRunningViewModel: PausedRunningViewModelTypes {
    var inputs: PausedRunningViewModelInputs { self }
    var outputs: PausedRunningViewModelOutputs { self }
}
