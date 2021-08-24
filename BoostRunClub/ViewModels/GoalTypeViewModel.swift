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
    // Data For Configure
    var goalTypeSubject: CurrentValueSubject<GoalType, Never> { get }

    // Signal For Coordinate
    var closeSignal: PassthroughSubject<GoalType, Never> { get }
}

class GoalTypeViewModel: GoalTypeViewModelInputs, GoalTypeViewModelOutputs {
    init(goalType: GoalType) {
        goalTypeSubject = CurrentValueSubject<GoalType, Never>(goalType)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // MARK: Inputs

    func didTapBackgroundView() {
        closeSignal.send(goalTypeSubject.value)
    }

    func didSelectGoalType(_ goalType: GoalType) {
        goalTypeSubject.send(goalType)
        closeSignal.send(goalTypeSubject.value)
    }

    // MARK: Ouputs

    private(set) var closeSignal = PassthroughSubject<GoalType, Never>()
    let goalTypeSubject: CurrentValueSubject<GoalType, Never>
}

// MARK: - Types

extension GoalTypeViewModel: GoalTypeViewModelTypes {
    var inputs: GoalTypeViewModelInputs { self }
    var outputs: GoalTypeViewModelOutputs { self }
}
