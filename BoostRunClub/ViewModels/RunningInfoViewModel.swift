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
    let items: [RunningInfoType]
    init(goalType: GoalType, goalValue _: String) {
        items = goalType == .speed ? RunningInfoType.allCases : RunningInfoType.allCases.filter { $0.value != "" }

        let presentingDataType: [RunningInfoType] = [.time(""), .pace(""), .averagePace(""), .kilometer("")]
        presentingDataType.forEach {
            runningInfoObservable.append(CurrentValueSubject<RunningInfoType, Never>($0))
        }
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    func didTapRunData(index: Int) {
        let currIdx = runningInfoObservable[index].value.index
        let nextItem = items[(currIdx + 1) % items.count]
        runningInfoObservable[index].send(nextItem)
    }

    // MARK: Outputs

    var runningInfoObservable = [CurrentValueSubject<RunningInfoType, Never>]()
}

// MARK: - Types

extension RunningInfoViewModel: RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { self }
    var outputs: RunningInfoViewModelOutputs { self }
}
