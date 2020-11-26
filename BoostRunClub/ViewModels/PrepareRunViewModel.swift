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
    func didChangeGoalValue(_ goalValue: String)
    func didTapGoalValueButton()
}

protocol PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var goalTypeObservable: CurrentValueSubject<GoalType, Never> { get }
    var goalValueObservable: CurrentValueSubject<String, Never> { get }
}

class PrepareRunViewModel: PrepareRunViewModelInputs, PrepareRunViewModelOutputs {
    let locationProvider: LocationProvidable
    weak var coordinator: PrepareRunCoordinatorProtocol?
    var cancellables = Set<AnyCancellable>()

    init(locationProvider: LocationProvidable = LocationProvider.shared) {
        self.locationProvider = locationProvider
    }

    // MARK: Inputs

    func didTapShowProfileButton() {}

    func didTapSetGoalButton() {
        coordinator?.showGoalTypeActionSheet(goalType: goalTypeObservable.value).sink(receiveValue: { goalType in
            self.goalTypeObservable.send(goalType)
            self.goalValueObservable.send(goalType.initialValue)
        }).store(in: &cancellables)
    }

    func didTapStartButton() {
        coordinator?.showRunningScene(goalTypeObservable.value)
    }

    func didChangeGoalType(_ goalType: GoalType) {
        goalTypeObservable.send(goalType)
        goalValueObservable.send(goalType.initialValue)
    }

    func didTapGoalValueButton() {
        coordinator?.showGoalValueSetupViewController(
            goalType: goalTypeObservable.value,
            goalValue: goalValueObservable.value
        ).compactMap { $0 }
            .sink(receiveValue: { goalValue in
                self.goalValueObservable.send(goalValue)
            }).store(in: &cancellables)
    }

    func didChangeGoalValue(_ goalValue: String) {
        goalValueObservable.send(goalValue)
    }

    // MARK: Outputs

    var goalTypeObservable = CurrentValueSubject<GoalType, Never>(.none)
    var goalValueObservable = CurrentValueSubject<String, Never>("")
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> {
        locationProvider.locationSubject
            .compactMap { $0.first?.coordinate }
            .eraseToAnyPublisher()
    }
}

// MARK: - Types

extension PrepareRunViewModel: PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { self }
    var outputs: PrepareRunViewModelOutputs { self }
}
