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
    func didSelectCell(at index: Int)
    func didTapBackgroundView()
}

protocol GoalTypeViewModelOutputs {
    var closeSheetSignal: PassthroughSubject<GoalType, Never> { get }
    var goalTypeObservable: CurrentValueSubject<GoalType, Never> { get }
    var numberOfCell: Int { get }
    func cellForRowAt(index: Int) -> GoalType
}

class GoalTypeViewModel: GoalTypeViewModelInputs, GoalTypeViewModelOutputs {
    init(goalType: GoalType) {
        goalTypeObservable = CurrentValueSubject<GoalType, Never>(goalType)
    }

    // MARK: Inputs

    func didTapBackgroundView() {
        closeSheetSignal.send(goalTypeObservable.value)
    }

    func didSelectCell(at _: Int) {
        closeSheetSignal.send(goalTypeObservable.value)
    }

    // MARK: Ouputs

    private(set) var closeSheetSignal = PassthroughSubject<GoalType, Never>()
    let goalTypeObservable: CurrentValueSubject<GoalType, Never>
    var numberOfCell: Int { 3 }

    func cellForRowAt(index: Int) -> GoalType {
        return GoalType(rawValue: index) ?? .none
    }
}

// MARK: - Types

extension GoalTypeViewModel: GoalTypeViewModelTypes {
    var inputs: GoalTypeViewModelInputs { self }
    var outputs: GoalTypeViewModelOutputs { self }
}
