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
    func didTapStopRunningButton()
    func viewDidAppear()
    func closeAnimationEnded()
}

protocol PausedRunningViewModelOutputs {
    var showRunningInfoSignal: PassthroughSubject<Void, Never> { get }
    var showRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var closeRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var runInfoData: [RunningInfo] { get }
}

class PausedRunningViewModel: PausedRunningViewModelInputs, PausedRunningViewModelOutputs {
    var runningProvider = RunningDataProvider()

    init() {
        var avgPace = 0
        if !runningProvider.locations.isEmpty {
            avgPace = runningProvider.totalPace / runningProvider.locations.count
        }

        let pace = runningProvider.pace

        runInfoData = [
            RunningInfo(type: .kilometer, value: String(format: "%.2f", runningProvider.distance)),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", avgPace / 60, avgPace % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", pace / 60, pace % 60)),
            RunningInfo(type: .kilometer, value: String(format: "%.2f", runningProvider.distance)),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", avgPace / 60, avgPace % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", pace / 60, pace % 60)),
        ]
    }

    // Inputs
    func didTapResumeButton() {
        closeRunningInfoAnimationSignal.send()
    }

    func didTapStopRunningButton() {}

    func viewDidAppear() {
        showRunningInfoAnimationSignal.send()
    }

    func closeAnimationEnded() {
        showRunningInfoSignal.send()
    }

    // Outputs
    var showRunningInfoSignal = PassthroughSubject<Void, Never>()
    var showRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var closeRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var runInfoData: [RunningInfo]
}

extension PausedRunningViewModel: PausedRunningViewModelTypes {
    var inputs: PausedRunningViewModelInputs { self }
    var outputs: PausedRunningViewModelOutputs { self }
}
