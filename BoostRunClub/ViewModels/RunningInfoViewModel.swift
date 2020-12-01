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
    typealias RunningInfoTypeSubject = CurrentValueSubject<RunningInfoType, Never>

    var runningInfoObservables: [RunningInfoTypeSubject] { get }
    var runningInfoTapAnimations: [PassthroughSubject<Void, Never>] { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
//    let runningProvider: RunningDataProvider

    private var cancellables = Set<AnyCancellable>()

    private let possibleTypes: [RunningInfoType: String]

    init(goalType: GoalType, goalValue _: String) {
        possibleTypes = RunningInfoType.getPossibleTypes(from: goalType)
            .reduce(into: [:]) { $0[$1] = $1.initialValue }

//        runningProvider = RunningDataProvider()
//        runningProvider.start()
//
//        runningProvider.elapsedTime
//            // .debounce(for: .seconds(1), scheduler: RunLoop.main)
//            .map { $0.formattedString }
//            .sink { timeString in
//                self.possibleTypes[RunningInfoType.time("").index] = RunningInfoType.time(timeString)
//                self.runningInfoObservables.forEach {
//                    switch $0.value {
//                    case .time:
//                        $0.send(.time(timeString))
//                    default:
//                        break
//                    }
//                }
//            }.store(in: &cancellables)
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        var nextType = runningInfoObservables[index].value.circularNext()
        nextType = possibleTypes[nextType] != nil ? nextType : RunningInfoType.allCases[0]
        runningInfoObservables[index].send(nextType)
        runningInfoTapAnimations[index].send()
    }

    // MARK: Outputs

    var runningInfoObservables = [
        RunningInfoTypeSubject(.time),
        RunningInfoTypeSubject(.pace),
        RunningInfoTypeSubject(.averagePace),
        RunningInfoTypeSubject(.kilometer),
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
