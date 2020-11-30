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

    var runningInfoObservable: [RunningInfoTypeSubject] { get }
    var runningInfoTapAnimations: [PassthroughSubject<Void, Never>] { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
    private let possibleTypes: [RunningInfoType]

    init(goalType: GoalType, goalValue _: String) {
        possibleTypes = RunningInfoType.getPossibleTypes(from: goalType)
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        let currIdx = runningInfoObservable[index].value.index
        let nextItem = possibleTypes[(currIdx + 1) % possibleTypes.count]
        runningInfoObservable[index].send(nextItem)
        runningInfoTapAnimations[index].send()
    }

    // MARK: Outputs

    var runningInfoObservable = [
        RunningInfoTypeSubject(.time(RunningInfoType.time("").initialValue)),
        RunningInfoTypeSubject(.pace(RunningInfoType.pace("").initialValue)),
        RunningInfoTypeSubject(.averagePace(RunningInfoType.averagePace("").initialValue)),
        RunningInfoTypeSubject(.kilometer(RunningInfoType.kilometer("").initialValue)),
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
