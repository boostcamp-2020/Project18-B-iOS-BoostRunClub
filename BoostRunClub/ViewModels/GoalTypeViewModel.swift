//
//  GoalTypeViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/24.
//

import Combine
import Foundation

protocol GoalTypeViewModelTypes {
    var inputs: GoalTypeViewModelInputs { get }
    var outputs: GoalTypeViewModelOutputs { get }
}

protocol GoalTypeViewModelInputs {
    func didSelectGoalType(_ goalType: GoalType)
    func didTapBackgroundView()
}

protocol GoalTypeViewModelOutputs {
    var closeSheetSignal: PassthroughSubject<GoalType, Never> { get }
    var goalTypeObservable: CurrentValueSubject<GoalType, Never> { get }
}

class GoalTypeViewModel: GoalTypeViewModelInputs, GoalTypeViewModelOutputs {
    init(goalType: GoalType) {
        goalTypeObservable = CurrentValueSubject<GoalType, Never>(goalType)
    }

    // MARK: Inputs

    func didTapBackgroundView() {
        closeSheetSignal.send(goalTypeObservable.value)
    }

    func didSelectGoalType(_ goalType: GoalType) {
        goalTypeObservable.send(goalType)
        closeSheetSignal.send(goalTypeObservable.value)
    }

    // MARK: Ouputs

    private(set) var closeSheetSignal = PassthroughSubject<GoalType, Never>()
    let goalTypeObservable: CurrentValueSubject<GoalType, Never>
}

// MARK: - Types

extension GoalTypeViewModel: GoalTypeViewModelTypes {
    var inputs: GoalTypeViewModelInputs { self }
    var outputs: GoalTypeViewModelOutputs { self }
}
