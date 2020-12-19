//
//  GoalValueSetupViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/26.
//

import Combine
import Foundation

protocol GoalValueSetupViewModelTypes {
    var inputs: GoalValueSetupViewModelInputs { get }
    var outputs: GoalValueSetupViewModelOutputs { get }
}

protocol GoalValueSetupViewModelInputs {
    func didDeleteBackward()
    func didInputNumber(_ number: String)
    func didTapCancelButton()
    func didTapApplyButton()
}

protocol GoalValueSetupViewModelOutputs {
    var goalType: GoalType { get }
    var goalValueSubject: CurrentValueSubject<String, Never> { get }

    var closeSignal: PassthroughSubject<String?, Never> { get }
}

class GoalValueSetupViewModel: GoalValueSetupViewModelInputs, GoalValueSetupViewModelOutputs {
    var goalType: GoalType
    private var inputValue = ""

    init(goalType: GoalType, goalValue: String) {
        self.goalType = goalType
        goalValueSubject = CurrentValueSubject<String, Never>(goalValue)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // MARK: Inputs

    func didInputNumber(_ number: String) {
        let currentString = inputValue
        switch goalType {
        case .distance:
            let text = currentString + number
            if text ~= String.RegexPattern.distance.patternString {
                inputValue = text
                goalValueSubject.send(text)
            }
        case .time:
            guard
                !(currentString.isEmpty && number == "0"),
                currentString.count < 4
            else { return }

            inputValue = currentString + number
            var outputValue = String(repeating: "0", count: 4 - inputValue.count) + inputValue
            outputValue.insert(contentsOf: ":", at: outputValue.index(outputValue.startIndex, offsetBy: 2))
            goalValueSubject.send(outputValue)

        case .speed, .none:
            break
        }
    }

    func didDeleteBackward() {
        if !inputValue.isEmpty {
            inputValue.removeLast()
        }
        switch goalType {
        case .distance:
            goalValueSubject.send(inputValue.isEmpty ? "0" : inputValue)
        case .time:
            var outputValue = String(repeating: "0", count: 4 - inputValue.count) + inputValue
            outputValue.insert(contentsOf: ":", at: outputValue.index(outputValue.startIndex, offsetBy: 2))
            goalValueSubject.send(outputValue)
        case .speed, .none:
            break
        }
    }

    func didTapCancelButton() {
        closeSignal.send(nil)
    }

    func didTapApplyButton() {
        var goalValue = goalValueSubject.value
        switch goalType {
        case .distance:
            guard let number = Float(goalValue) else {
                goalValue = "00.00"
                break
            }
            goalValue = String(format: "%.2f", number)
        case .time, .speed, .none:
            break
        }
        closeSignal.send(goalValue)
    }

    // MARK: Outputs

    var goalValueSubject: CurrentValueSubject<String, Never>

    var closeSignal = PassthroughSubject<String?, Never>()
}

// MARK: - Types

extension GoalValueSetupViewModel: GoalValueSetupViewModelTypes {
    var inputs: GoalValueSetupViewModelInputs { self }
    var outputs: GoalValueSetupViewModelOutputs { self }
}
