//
//  GoalTypeViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/11/24.
//

import Combine
import Foundation

protocol GoalTypeViewModelTypes {
    var input: GoalTypeViewModelInputs { get }
    var output: GoalTypeViewModelOutputs { get }
}

protocol GoalTypeViewModelInputs {
    func didSelectCell(at index: Int)
    func didTapBackgroundView()
}

protocol GoalTypeViewModelOutputs {
    var closeSheet: PassthroughSubject<Void, Never> { get }
    var goalTypeSubject: CurrentValueSubject<GoalType, Never> { get }
    var numberOfCell: Int { get }
    func cellForRowAt(index: Int) -> GoalType
}

class GoalTypeViewModel {
    var closeSheet = PassthroughSubject<Void, Never>()
    let goalTypeSubject: CurrentValueSubject<GoalType, Never>
    let sendGoalType: (GoalType) -> Void

    init(goalType: GoalType, completion: @escaping (GoalType) -> Void) {
        sendGoalType = completion
        goalTypeSubject = CurrentValueSubject<GoalType, Never>(goalType)
    }
}

// MARK: - Inputs

extension GoalTypeViewModel: GoalTypeViewModelInputs {
    func didTapBackgroundView() {
        closeSheet.send()
    }

    func didSelectCell(at index: Int) {
        if let goalType = GoalType(rawValue: index) {
            sendGoalType(goalType)
        }
        closeSheet.send()
    }
}

// MARK: - Outputs

extension GoalTypeViewModel: GoalTypeViewModelOutputs {
    func cellForRowAt(index: Int) -> GoalType {
        return GoalType(rawValue: index) ?? .none
    }

    var numberOfCell: Int { 3 }
}

// MARK: - Types

extension GoalTypeViewModel: GoalTypeViewModelTypes {
    var input: GoalTypeViewModelInputs { self }
    var output: GoalTypeViewModelOutputs { self }
}
