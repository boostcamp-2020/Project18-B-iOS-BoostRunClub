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
}

protocol PrepareRunViewModelOutputs {
    var userLocation: AnyPublisher<CLLocationCoordinate2D, Never> { get }
}

class PrepareRunViewModel {
    let locationProvider: LocationProvidable
    weak var coordinator: PrepareRunCoordinatorProtocol?

    init(locationProvider: LocationProvidable = LocationProvider.shard) {
        self.locationProvider = locationProvider
    }
}

// MARK: - Inputs

extension PrepareRunViewModel: PrepareRunViewModelInputs {
    func didTapShowProfileButton() {}

    func didTapSetGoalButton() {
        coordinator?.showGoalTypeActionSheet(completion: { _ in

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
}

// MARK: - Types

extension PrepareRunViewModel: PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { self }
    var outputs: PrepareRunViewModelOutputs { self }
}
