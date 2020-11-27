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
}

protocol RunningViewModelOutputs {
    var runningInfoObservable: [RunningInfoType: PassthroughSubject<String, Never>] { get }
}

class RunningViewModel: RunningViewModelInputs, RunningViewModelOutputs {
    let goalValue: String
    var cancellables = Set<AnyCancellable>()

    init(goalType: GoalType, goalValue: String) {
        self.goalValue = goalValue
        makeRunningInfoObservables(from: goalType)

        // TODO: Running 계층 만들기
        LocationProvider.shared.locationSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.runningInfoObservable.forEach {
                    $0.value.send(String(Int.random(in: 100 ... 200)))
                }
            }
            .store(in: &cancellables)
    }

    private func makeRunningInfoObservables(from goalType: GoalType) {
        RunningInfoType.allCases
            .filter { goalType == .speed || ($0 != .meter && $0 != .interval) }
            .forEach { self.runningInfoObservable[$0] = PassthroughSubject<String, Never>() }
    }

    // MARK: Inputs

    func didTapPauseButton() {}

    // MARK: Outputs

    var runningInfoObservable = [RunningInfoType: PassthroughSubject<String, Never>]()
}

// MARK: - Types

extension RunningViewModel: RunningViewModelTypes {
    var inputs: RunningViewModelInputs { self }
    var outputs: RunningViewModelOutputs { self }
}
