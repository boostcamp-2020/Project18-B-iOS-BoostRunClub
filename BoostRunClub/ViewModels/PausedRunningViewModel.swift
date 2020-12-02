//
//  PausedRunningViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/01.
//

import Combine
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
}

class PausedRunningViewModel: PausedRunningViewModelInputs, PausedRunningViewModelOutputs {
    let runningDataProvider: RunningDataServiceable

    // TODO: RunningDataProvicer Protocol 구현
    init(runningDataProvider: RunningDataServiceable) {
        self.runningDataProvider = runningDataProvider
        let avgPace = runningDataProvider.avgPace.value
        let pace = runningDataProvider.pace.value

        runInfoData = [
            RunningInfo(type: .time, value: runningDataProvider.runningTime.value.formattedString),
//            RunningInfo(type: .kilometer, value: String(format: "%.2f", runningProvider.distance)),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", avgPace / 60, avgPace % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", pace / 60, pace % 60)),
            RunningInfo(type: .kilometer, value: String(format: "%.2f", runningDataProvider.distance.value / 1000)),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", avgPace / 60, avgPace % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", pace / 60, pace % 60)),
        ]
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
    var showRunningInfoSignal = PassthroughSubject<Void, Never>()
    var showRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var closeRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var runningInfoTapAnimationSignal = PassthroughSubject<Int, Never>()
    var showPrepareRunningSignal = PassthroughSubject<Void, Never>()
    var runInfoData: [RunningInfo]
}

extension PausedRunningViewModel: PausedRunningViewModelTypes {
    var inputs: PausedRunningViewModelInputs { self }
    var outputs: PausedRunningViewModelOutputs { self }
}
