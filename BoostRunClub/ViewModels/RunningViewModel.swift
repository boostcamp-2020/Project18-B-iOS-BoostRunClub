//
//  RunningViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/25.
//

import Combine
import Foundation

protocol RunningViewModelTypes {
    var inputs: RunningViewModelInputs { get }
    var outputs: RunningViewModelOutputs { get }
}

protocol RunningViewModelInputs {
    func didTapPauseButton()
    func didTapRunData(index: Int)
}

protocol RunningViewModelOutputs {
    var runningInfoObservable: [CurrentValueSubject<RunningInfo, Never>] { get }
}

class RunningViewModel: RunningViewModelInputs, RunningViewModelOutputs {
    init(goalType _: GoalType, goalValue _: String) {
        let presentingDataType: [RunningInfoType] = [.time, .pace, .averagePace, .kilometer]
        presentingDataType.forEach {
            runningInfoObservable.append(CurrentValueSubject<RunningInfo, Never>(RunningInfo(type: $0, value: "")))
        }
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        let runInfo = runningInfoObservable[index].value
    }

    // MARK: Outputs

    var runningInfoObservable = [CurrentValueSubject<RunningInfo, Never>]()
}

// MARK: - Types

extension RunningViewModel: RunningViewModelTypes {
    var inputs: RunningViewModelInputs { self }
    var outputs: RunningViewModelOutputs { self }
}
