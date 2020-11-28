//
//  PrepareRunViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/24.
//

import Combine
import CoreLocation
import Foundation

protocol PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { get }
    var outputs: PrepareRunViewModelOutputs { get }
}

protocol PrepareRunViewModelInputs {
    func didTapShowProfileButton()
    func didTapSetGoalButton()
    func didTapStartButton()
    func didChangeGoalType(_ goalType: GoalType)
    func didChangeGoalValue(_ goalValue: String?)
    func didTapGoalValueButton()
}

protocol PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var goalTypeObservable: CurrentValueSubject<GoalType, Never> { get }
    var goalValueObservable: CurrentValueSubject<String, Never> { get } // TODO: - GoalType/value observable을 goalInfo로 바꿀지 생각해보기
    var goalValueSetupClosed: PassthroughSubject<Void, Never> { get }
    var goalTypeSetupClosed: PassthroughSubject<Void, Never> { get }
    var showGoalTypeActionSheetSignal: PassthroughSubject<GoalType, Never> { get }
    var showGoalValueSetupSceneSignal: PassthroughSubject<GoalInfo, Never> { get }
    var showRunningSceneSignal: PassthroughSubject<GoalInfo, Never> { get }
}

class PrepareRunViewModel: PrepareRunViewModelInputs, PrepareRunViewModelOutputs {
    let locationProvider: LocationProvidable

    var cancellables = Set<AnyCancellable>()
    private var goalInfo: GoalInfo {
        GoalInfo(
            goalType: goalTypeObservable.value,
            goalValue: goalValueObservable.value
        )
    }

    init(locationProvider: LocationProvidable = LocationProvider.shared) {
        self.locationProvider = locationProvider
    }

    // MARK: Inputs

    func didTapShowProfileButton() {}

    func didTapSetGoalButton() {
        showGoalTypeActionSheetSignal.send(goalTypeObservable.value)
    }

    func didTapStartButton() {
        showRunningSceneSignal.send(goalInfo)
    }

    func didTapGoalValueButton() {
        showGoalValueSetupSceneSignal.send(goalInfo)
    }

    func didChangeGoalType(_ goalType: GoalType) {
        if goalType != goalTypeObservable.value {
            goalTypeObservable.send(goalType)
            goalValueObservable.send(goalType.initialValue)
            if goalType != .none {
                goalTypeSetupClosed.send()
            }
        }
    }

    func didChangeGoalValue(_ goalValue: String?) {
        goalValueSetupClosed.send()
        if let goalValue = goalValue {
            goalValueObservable.send(goalValue)
        }
    }

    // MARK: Outputs

    var goalTypeObservable = CurrentValueSubject<GoalType, Never>(.none)
    var goalValueObservable = CurrentValueSubject<String, Never>("")
    var goalValueSetupClosed = PassthroughSubject<Void, Never>()
    var goalTypeSetupClosed = PassthroughSubject<Void, Never>()
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> {
        locationProvider.locationSubject
            .compactMap { $0.first?.coordinate }
            .eraseToAnyPublisher()
    }

    var showGoalTypeActionSheetSignal = PassthroughSubject<GoalType, Never>()
    var showGoalValueSetupSceneSignal = PassthroughSubject<GoalInfo, Never>()
    var showRunningSceneSignal = PassthroughSubject<GoalInfo, Never>()
}

// MARK: - Types

extension PrepareRunViewModel: PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { self }
    var outputs: PrepareRunViewModelOutputs { self }
}
