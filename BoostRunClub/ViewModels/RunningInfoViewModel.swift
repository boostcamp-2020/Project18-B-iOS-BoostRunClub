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
}

protocol RunningInfoViewModelOutputs {
    typealias RunningInfoTypeSubject = CurrentValueSubject<RunningInfo, Never>

    var runningInfoObservables: [RunningInfoTypeSubject] { get }
    var runningInfoTapAnimations: [PassthroughSubject<Void, Never>] { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
    let runningProvider: RunningDataProvider

    private var cancellables = Set<AnyCancellable>()

    private var possibleTypes: [RunningInfoType: String]

    init(goalType: GoalType, goalValue _: String) {
        possibleTypes = RunningInfoType.getPossibleTypes(from: goalType)
            .reduce(into: [:]) { $0[$1] = $1.initialValue }

        runningProvider = RunningDataProvider()
        runningProvider.start()

        runningProvider.elapsedTime
            // .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .map { $0.formattedString }
            .sink { timeString in
                print(timeString)
                self.possibleTypes[RunningInfoType.time] = timeString
                self.runningInfoObservables.forEach {
                    $0.send(RunningInfo(type: .time, value: timeString))
                }
            }.store(in: &cancellables)
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        var nextType = runningInfoObservables[index].value.type.circularNext()
        nextType = possibleTypes[nextType] != nil ? nextType : RunningInfoType.allCases[0]
        runningInfoObservables[index].send(RunningInfo(type: nextType, value: possibleTypes[nextType, default: nextType.initialValue]))
        runningInfoTapAnimations[index].send()
    }

    // MARK: Outputs

    var runningInfoObservables = [
        RunningInfoTypeSubject(RunningInfo(type: .time)),
        RunningInfoTypeSubject(RunningInfo(type: .pace)),
        RunningInfoTypeSubject(RunningInfo(type: .averagePace)),
        RunningInfoTypeSubject(RunningInfo(type: .kilometer)),
    ]
    var runningInfoTapAnimations = [
        PassthroughSubject<Void, Never>(),
        PassthroughSubject<Void, Never>(),
        PassthroughSubject<Void, Never>(),
        PassthroughSubject<Void, Never>(),
    ]
}

// MARK: - Types

extension RunningInfoViewModel: RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { self }
    var outputs: RunningInfoViewModelOutputs { self }
}
