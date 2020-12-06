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
    let runningDataProvider: RunningDataServiceable

    init(runningDataProvider: RunningDataServiceable) {
        // TODO: GOALTYPE - SPEED 제거
        possibleTypes = RunningInfoType.getPossibleTypes(from: .none)
            .reduce(into: [:]) { $0[$1] = $1.initialValue }

        self.runningDataProvider = runningDataProvider

        runningDataProvider.runningTime
            .map { $0.formattedString }
            .sink { timeString in
                self.possibleTypes[.time] = timeString

                self.runningInfoObservables.forEach {
                    if $0.value.type == .time {
                        $0.send(RunningInfo(type: .time, value: timeString))
                    }
                }
            }.store(in: &cancellables)

        runningDataProvider.distance
            .map { String(format: "%.2f", $0 / 1000) }
            .sink { distance in
                self.possibleTypes[.kilometer] = distance
                self.runningInfoObservables.forEach {
                    if $0.value.type == .kilometer {
                        $0.send(RunningInfo(type: .kilometer, value: distance))
                    }
                }
            }.store(in: &cancellables)

        runningDataProvider.pace
            .map { String(format: "%d'%d\"", $0 / 60, $0 % 60) }
            .sink { pace in
                self.possibleTypes[.pace] = pace
                self.runningInfoObservables.forEach {
                    if $0.value.type == .pace {
                        $0.send(RunningInfo(type: .pace, value: pace))
                    }
                }
            }.store(in: &cancellables)

        runningDataProvider.avgPace
            .map { String(format: "%d'%d\"", $0 / 60, $0 % 60) }
            .sink { averagePace in
                self.possibleTypes[.averagePace] = averagePace
                self.runningInfoObservables.forEach {
                    if $0.value.type == .averagePace {
                        $0.send(RunningInfo(type: .averagePace, value: averagePace))
                    }
                }
            }.store(in: &cancellables)

        runningDataProvider.calorie
            .map { String(Int($0)) }
            .sink { calorie in
                self.possibleTypes[.calorie] = calorie
                self.runningInfoObservables.forEach {
                    if $0.value.type == .calorie {
                        $0.send(RunningInfo(type: .calorie, value: calorie))
                    }
                }
            }.store(in: &cancellables)

        runningDataProvider.cadence
            .map { String($0) }
            .sink { cadence in
                self.possibleTypes[.cadence] = cadence
                self.runningInfoObservables.forEach {
                    if $0.value.type == .cadence {
                        $0.send(RunningInfo(type: .cadence, value: cadence))
                    }
                }
            }.store(in: &cancellables)
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
