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
    var name: String {
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
}

protocol PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
    var goalTypePublisher: Published<GoalType>.Publisher { get }
}

class PrepareRunViewModel {
    init(locationProvider: LocationProvidable = LocationProvider.shared) {
        self.locationProvider = locationProvider
    }

    let locationProvider: LocationProvidable
    weak var coordinator: PrepareRunCoordinatorProtocol?
    @Published var goalType: GoalType = .none
}

// MARK: - Inputs

extension PrepareRunViewModel: PrepareRunViewModelInputs {
    func didTapShowProfileButton() {}

    func didTapSetGoalButton() {
        coordinator?.showGoalTypeActionSheet(goalType: goalType, completion: { _ in
            print("goal Type selected")
        })
    }

    func didTapStartButton() {}
}

// MARK: - Outputs

extension PrepareRunViewModel: PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> {
        locationProvider.locationSubject
            .compactMap { $0.first?.coordinate }
            .eraseToAnyPublisher()
    }

    var goalTypePublisher: Published<GoalType>.Publisher {
        $goalType
    }
}

// MARK: - Types

extension PrepareRunViewModel: PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { self }
    var outputs: PrepareRunViewModelOutputs { self }
}
