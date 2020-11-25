//
//  PrepareRunViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/24.
//

import Combine
import CoreLocation
import Foundation

enum GoalType: Int {
    case distance, time, speed, none

    var description: String {
        switch self {
        case .distance:
            return "거리"
        case .time:
            return "시간"
        case .speed:
            return "속도"
        case .none:
            return "없음"
        }
    }
}

protocol PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { get }
    var outputs: PrepareRunViewModelOutputs { get }
}

protocol PrepareRunViewModelInputs {
    func didTapShowProfileButton()
    func didTapSetGoalButton()
    func didTapStartButton()
    func didChangeGoalType(_ goalType: GoalType)
}

protocol PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var goalTypeObservable: CurrentValueSubject<GoalType, Never> { get }
    var goalValueObservable: CurrentValueSubject<String, Never> { get }
}

class PrepareRunViewModel: PrepareRunViewModelInputs, PrepareRunViewModelOutputs {
    let locationProvider: LocationProvidable
    weak var coordinator: PrepareRunCoordinatorProtocol?

    init(locationProvider: LocationProvidable = LocationProvider.shared) {
        self.locationProvider = locationProvider
    }

    // MARK: Inputs

    func didTapShowProfileButton() {}

    func didTapSetGoalButton() {
        coordinator?.showGoalTypeActionSheet(goalType: goalTypeObservable.value)
    }

    func didTapStartButton() {
        coordinator?.showRunningScene(goalTypeObservable.value)
    }

    func didChangeGoalType(_ goalType: GoalType) {
        goalTypeObservable.send(goalType)
        print(goalTypeObservable.value)
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
