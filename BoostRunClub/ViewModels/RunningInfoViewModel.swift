//
//  RunningInfoViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/25.
//

import Combine
import Foundation

protocol RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { get }
    var outputs: RunningInfoViewModelOutputs { get }
}

protocol RunningInfoViewModelInputs {
    func didTapPauseButton()
    func didTapRunData(index: Int)
}

protocol RunningInfoViewModelOutputs {
    var runningInfoObservable: [CurrentValueSubject<RunningInfoType, Never>] { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
    init(goalType _: GoalType, goalValue _: String) {
        let presentingDataType: [RunningInfoType] = [.time(""), .pace(""), .averagePace(""), .kilometer("")]
        presentingDataType.forEach {
            runningInfoObservable.append(CurrentValueSubject<RunningInfoType, Never>($0))
        }
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        let currentIndex = runningInfoObservable[index].value.index
        let nextIndex = currentIndex + 1 > RunningInfoType.allCases.count
        let nextType = RunningInfoType.allCases[currentIndex + 1].value.isEmpty ? RunningInfoType.allCases[0].value : RunningInfoType.allCases[currentIndex + 1].value
    }

    // MARK: Outputs

    var runningInfoObservable = [CurrentValueSubject<RunningInfoType, Never>]()
}

// MARK: - Types

extension RunningInfoViewModel: RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { self }
    var outputs: RunningInfoViewModelOutputs { self }
}
