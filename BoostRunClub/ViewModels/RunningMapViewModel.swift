//
//  RunningMapViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Combine
import CoreLocation
import Foundation

protocol RunningMapViewModelTypes {
    var inputs: RunningMapViewModelInputs { get }
    var outputs: RunningMapViewModelOutputs { get }
}

protocol RunningMapViewModelInputs {
    func viewWillAppear()
    func didTapLocateButton()
    func didTapExitButton()
    func viewWillDisappear()
}

protocol RunningMapViewModelOutputs {
    var routesSubject: PassthroughSubject<[CLLocationCoordinate2D], Never> { get }
    var userTrackingModeOnWithAnimatedSignal: PassthroughSubject<Bool, Never> { get }
    var userTrackingModeOffSignal: PassthroughSubject<Void, Never> { get }
    var closeRunningMapSceneSignal: PassthroughSubject<Void, Never> { get }
    var closeAnimationSignal: PassthroughSubject<Void, Never> { get }
    var appearAnimationSignal: PassthroughSubject<Void, Never> { get }
}

class RunningMapViewModel: RunningMapViewModelInputs, RunningMapViewModelOutputs {
    private let runningDataProvider: RunningDataServiceable
    private var lastRouteIdx = 0

    init(runningDataProvider: RunningDataServiceable) {
        self.runningDataProvider = runningDataProvider
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // inputs
    func viewWillAppear() {
        userTrackingModeOnWithAnimatedSignal.send(false)
        appearAnimationSignal.send()
        guard
            !runningDataProvider.locations.isEmpty,
            lastRouteIdx + 1 < runningDataProvider.locations.count
        else { return }
        routesSubject.send(runningDataProvider.locations[lastRouteIdx...].map { $0.coordinate })
        lastRouteIdx = runningDataProvider.locations.count - 1
    }

    func viewWillDisappear() {
        userTrackingModeOffSignal.send()
        closeAnimationSignal.send()
    }

    func didTapLocateButton() {
        userTrackingModeOnWithAnimatedSignal.send(true)
    }

    func didTapExitButton() {
        closeRunningMapSceneSignal.send()
    }

    // outputs
    var routesSubject = PassthroughSubject<[CLLocationCoordinate2D], Never>()
    var userTrackingModeOnWithAnimatedSignal = PassthroughSubject<Bool, Never>()
    var userTrackingModeOffSignal = PassthroughSubject<Void, Never>()
    var closeRunningMapSceneSignal = PassthroughSubject<Void, Never>()
    var closeAnimationSignal = PassthroughSubject<Void, Never>()
    var appearAnimationSignal = PassthroughSubject<Void, Never>()
}

extension RunningMapViewModel: RunningMapViewModelTypes {
    var inputs: RunningMapViewModelInputs { self }
    var outputs: RunningMapViewModelOutputs { self }
}
