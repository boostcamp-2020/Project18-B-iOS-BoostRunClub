//
//  RunningInfoViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/25.
//

import Combine
import Foundation

protocol RunningInfoViewModelTypes: AnyObject {
    var inputs: RunningInfoViewModelInputs { get }
    var outputs: RunningInfoViewModelOutputs { get }
}

protocol RunningInfoViewModelInputs {
    func didTapPauseButton()
    func didTapRunData(index: Int)
    func viewDidAppear()
}

protocol RunningInfoViewModelOutputs {
    typealias RunningInfoTypeSubject = CurrentValueSubject<RunningInfo, Never>

    var runningInfoObservables: [RunningInfoTypeSubject] { get }
    var runningInfoTapAnimation: PassthroughSubject<Int, Never> { get }
    var initialAnimation: PassthroughSubject<Void, Never> { get }
    var resumeAnimation: PassthroughSubject<Void, Never> { get }
    var showPausedRunningSignal: PassthroughSubject<Void, Never> { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
    private var cancellables = Set<AnyCancellable>()

    private var possibleTypes: [RunningInfoType: String]
    let runningDataProvider: RunningServiceType

    init(runningDataProvider: RunningServiceType) {
        // TODO: GOALTYPE - SPEED 제거
        possibleTypes = RunningInfoType.getPossibleTypes(from: .none)
            .reduce(into: [:]) { $0[$1] = $1.initialValue }

        self.runningDataProvider = runningDataProvider

        runningDataProvider.dashBoard.runningSubject
            .sink { [weak self] data in
                self?.runningInfoObservables.forEach {
                    let value: String
                    switch $0.value.type {
                    case .kilometer:
                        value = String(format: "%.2f", data.distance / 1000)
                    case .pace:
                        value = String(format: "%d'%d\"", data.pace / 60, data.pace % 60)
                    case .averagePace:
                        value = String(format: "%d'%d\"", data.avgPace / 60, data.avgPace % 60)
                    case .calorie:
                        value = data.calorie <= 0 ? "--" : String(data.calorie)
                    case .cadence:
                        value = data.cadence <= 0 ? "--" : String(data.cadence)
                    case .time, .interval, .bpm, .meter:
                        return
                    }
                    $0.send(RunningInfo(type: $0.value.type, value: value))
                }
            }
            .store(in: &cancellables)

        runningDataProvider.dashBoard.runningTime
            .map { $0.simpleFormattedString }
            .sink { [weak self] timeString in
                self?.possibleTypes[.time] = timeString

                self?.runningInfoObservables.forEach {
                    if $0.value.type == .time {
                        $0.send(RunningInfo(type: .time, value: timeString))
                    }
                }
            }.store(in: &cancellables)

//        runningDataProvider.distance
//            .map { String(format: "%.2f", $0 / 1000) }
//            .sink { [weak self] distance in
//                self?.possibleTypes[.kilometer] = distance
//                self?.runningInfoObservables.forEach {
//                    if $0.value.type == .kilometer {
//                        $0.send(RunningInfo(type: .kilometer, value: distance))
//                    }
//                }
//            }.store(in: &cancellables)

//        runningDataProvider.pace
//            .map { String(format: "%d'%d\"", $0 / 60, $0 % 60) }
//            .sink { [weak self] pace in
//                self?.possibleTypes[.pace] = pace
//                self?.runningInfoObservables.forEach {
//                    if $0.value.type == .pace {
//                        $0.send(RunningInfo(type: .pace, value: pace))
//                    }
//                }
//            }.store(in: &cancellables)

//        runningDataProvider.avgPace
//            .map { String(format: "%d'%d\"", $0 / 60, $0 % 60) }
//            .sink { [weak self] averagePace in
//                self?.possibleTypes[.averagePace] = averagePace
//                self?.runningInfoObservables.forEach {
//                    if $0.value.type == .averagePace {
//                        $0.send(RunningInfo(type: .averagePace, value: averagePace))
//                    }
//                }
//            }.store(in: &cancellables)

//        runningDataProvider.calorie
//            .map { $0 <= 0 ? "--" : String($0) }
//            .sink { [weak self] calorie in
//                self?.possibleTypes[.calorie] = calorie
//                self?.runningInfoObservables.forEach {
//                    if $0.value.type == .calorie {
//                        $0.send(RunningInfo(type: .calorie, value: calorie))
//                    }
//                }
//            }.store(in: &cancellables)

        runningDataProvider.runningState
//            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] currentMotionType in
                if currentMotionType == .standing {
                    self?.showPausedRunningSignal.send()
                }
            }.store(in: &cancellables)

//        runningDataProvider.cadence
//            .map { $0 <= 0 ? "--" :
//                String($0)
//            }
//            .sink { [weak self] cadence in
//                self?.possibleTypes[.cadence] = cadence
//                self?.runningInfoObservables.forEach {
//                    if $0.value.type == .cadence {
//                        $0.send(RunningInfo(type: .cadence, value: cadence))
//                    }
//                }
//            }.store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // MARK: Inputs

    func didTapPauseButton() {
        showPausedRunningSignal.send()
        runningDataProvider.pause()
    }

    func didTapRunData(index: Int) {
        var nextType = runningInfoObservables[index].value.type.circularNext()
        nextType = possibleTypes[nextType] != nil ? nextType : RunningInfoType.allCases[0]
        runningInfoObservables[index].send(
            RunningInfo(
                type: nextType,
                value: possibleTypes[nextType, default: nextType.initialValue]
            )
        )
        runningInfoTapAnimation.send(index)
    }

    func viewDidAppear() {
        if runningDataProvider.isRunning {
            resumeAnimation.send()
        } else {
            runningDataProvider.start()
            initialAnimation.send()
        }
    }

    // MARK: Outputs

    var runningInfoObservables = [
        RunningInfoTypeSubject(RunningInfo(type: .time)),
        RunningInfoTypeSubject(RunningInfo(type: .pace)),
        RunningInfoTypeSubject(RunningInfo(type: .averagePace)),
        RunningInfoTypeSubject(RunningInfo(type: .kilometer)),
    ]
    var runningInfoTapAnimation = PassthroughSubject<Int, Never>()
    var initialAnimation = PassthroughSubject<Void, Never>()
    var resumeAnimation = PassthroughSubject<Void, Never>()
    var showPausedRunningSignal = PassthroughSubject<Void, Never>()
}

// MARK: - Types

extension RunningInfoViewModel: RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { self }
    var outputs: RunningInfoViewModelOutputs { self }
}
