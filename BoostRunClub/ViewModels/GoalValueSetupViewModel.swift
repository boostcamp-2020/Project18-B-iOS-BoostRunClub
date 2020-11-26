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
    var goalValueObservable: CurrentValueSubject<String, Never> { get }
    var runningEstimationObservable: AnyPublisher<String, Never> { get }
    var closeSheetSignal: PassthroughSubject<String?, Never> { get }
    var goalType: GoalType { get }
}

class GoalValueSetupViewModel: GoalValueSetupViewModelInputs, GoalValueSetupViewModelOutputs {
    var goalType: GoalType
    var isFirstInput = true

    init(goalType: GoalType, goalValue: String) {
        self.goalType = goalType
        goalValueObservable = CurrentValueSubject<String, Never>(goalValue)
    }

    // MARK: Inputs

    func didInputNumber(_ number: String) {
        if isFirstInput {
            goalValueObservable.send(number)
            isFirstInput.toggle()
            return
        }

        var value = goalValueObservable.value.filter { $0 != ":" }
        value.append(number)

        switch goalType {
        case .distance:
            if value ~= String.RegexPattern.distance.patternString {
                goalValueObservable.send(value)
            }
        case .time:
            if (1 ... 4).contains(value.count) {}
        default:
            break
        }
    }

    func didDeleteBackward() {
        var value = goalValueObservable.value
        if value.isEmpty { return }
        value.removeLast()
        goalValueObservable.send(value)
    }

    func didTapCancelButton() {
        closeSheetSignal.send(goalValueObservable.value)
    }

    func didTapApplyButton() {
        closeSheetSignal.send(goalValueObservable.value)
    }

    // MARK: Outputs

    var goalValueObservable: CurrentValueSubject<String, Never>
    var runningEstimationObservable: AnyPublisher<String, Never> {
        return goalValueObservable.map {
            return $0
        }.eraseToAnyPublisher()
    }

    var closeSheetSignal = PassthroughSubject<String?, Never>()
}

// MARK: - Types

extension GoalValueSetupViewModel: GoalValueSetupViewModelTypes {
    var inputs: GoalValueSetupViewModelInputs { self }
    var outputs: GoalValueSetupViewModelOutputs { self }
}

extension String {
    enum RegexPattern {
        case distance, time
        var patternString: String {
            switch self {
            case .distance:
                return "^([0-9]{0,2}(\\.[0-9]{0,2})?|\\.?\\[0-9]{1,2})$"
            case .time:
                return ""
            }
        }
    }

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}

//
// func matches(for regex: String, in text: String) -> Bool {
//
//	do {
//		let regex = try NSRegularExpression(pattern: regex)
//		let results = regex.matches(in: text,
//									range: NSRange(text.startIndex..., in: text))
//
//		guard let str = results.map ({
//			String(text[Range($0.range, in: text)!])
//		}).first else { return false }
//
//		return str.count == text.count
//
//	} catch let error {
//		print("invalid regex: \(error.localizedDescription)")
//		return false
//	}
// }
