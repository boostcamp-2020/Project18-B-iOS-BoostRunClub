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
    func closeAnimationEnded()
    func didTapRunData(index: Int)

    // Life Cycle
    func viewDidAppear()
}

protocol PausedRunningViewModelOutputs {
    // Data For Configure
    var runInfoData: [RunningInfo] { get }
    var pathCoordinates: [CLLocationCoordinate2D] { get }
    var slices: [RunningSlice] { get }

    // Signal For View Action
    var showRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var closeRunningInfoAnimationSignal: PassthroughSubject<Void, Never> { get }
    var runningInfoTapAnimationSignal: PassthroughSubject<Int, Never> { get }

    // Signal For Coordinate
    var showRunningInfoSignal: PassthroughSubject<Void, Never> { get }
    var showPrepareRunningSignal: PassthroughSubject<Void, Never> { get }
    var showActivityDetailSignal: PassthroughSubject<(activity: Activity, detail: ActivityDetail), Never> { get }
}

class PausedRunningViewModel: PausedRunningViewModelInputs, PausedRunningViewModelOutputs {
    let runningService: RunningServiceType
    private var cancellables = Set<AnyCancellable>()

    // TODO: RunningDataProvicer Protocol 구현
    init(runningService: RunningServiceType) {
        self.runningService = runningService
        let runTime = runningService.dashBoardService.runningTime.value.simpleFormattedString
        let avgPace = runningService.dashBoardService.avgPace
        let pace = runningService.dashBoardService.pace
        let cadence = runningService.dashBoardService.cadence
        let calorie = runningService.dashBoardService.calorie
        let distance = runningService.dashBoardService.distance
        pathCoordinates = runningService.recordService.locations.map { $0.coordinate }
        runInfoData = [
            RunningInfo(type: .time, value: runTime),
            RunningInfo(type: .averagePace, value: String(format: "%d'%d\"", Int(avgPace) / 60, Int(avgPace) % 60)),
            RunningInfo(type: .pace, value: String(format: "%d'%d\"", Int(pace) / 60, Int(pace) % 60)),
            RunningInfo(type: .kilometer, value: String(format: "%.2f", distance / 1000)),
            RunningInfo(type: .calorie, value: calorie <= 0 ? "--" : String(calorie)),
            RunningInfo(type: .cadence, value: cadence <= 0 ? "--" : String(cadence)),
        ]

        runningService.runningStateSubject
            .sink { [weak self] currentMotionType in
                if currentMotionType == .running {
                    self?.runningService.resume()
                    self?.closeRunningInfoAnimationSignal.send()
                }
            }.store(in: &cancellables)

        runningService.runningResultSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                if let info = $0 {
                    self?.showActivityDetailSignal.send((info.activity, info.detail))
                } else {
                    self?.showPrepareRunningSignal.send()
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs
    func didTapResumeButton() {
        closeRunningInfoAnimationSignal.send()
        runningService.resume()
    }

    func didLongHoldStopRunningButton() {
        runningService.stop()
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
        runningService.recordService.routes
    }

    var showRunningInfoSignal = PassthroughSubject<Void, Never>()
    var showRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var closeRunningInfoAnimationSignal = PassthroughSubject<Void, Never>()
    var runningInfoTapAnimationSignal = PassthroughSubject<Int, Never>()
    var showPrepareRunningSignal = PassthroughSubject<Void, Never>()
    var showActivityDetailSignal = PassthroughSubject<(activity: Activity, detail: ActivityDetail), Never>()
}

extension PausedRunningViewModel: PausedRunningViewModelTypes {
    var inputs: PausedRunningViewModelInputs { self }
    var outputs: PausedRunningViewModelOutputs { self }
}
