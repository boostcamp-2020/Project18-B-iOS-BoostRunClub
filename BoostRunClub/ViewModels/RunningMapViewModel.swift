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
    func didTapLocateButton()
    func didTapExitButton()

    // Life Cycle
    func viewWillAppear()
    func viewWillDisappear()
}

protocol RunningMapViewModelOutputs {
    // Data For Configure
    var routesSubject: PassthroughSubject<[CLLocationCoordinate2D], Never> { get }

    // Signal For View Action
    var userTrackingModeOnWithAnimatedSignal: PassthroughSubject<Bool, Never> { get }
    var userTrackingModeOffSignal: PassthroughSubject<Void, Never> { get }
    var closeAnimationSignal: PassthroughSubject<Void, Never> { get }
    var appearAnimationSignal: PassthroughSubject<Void, Never> { get }

    // Signal For Coordinate
    var closeSignal: PassthroughSubject<Void, Never> { get }
}

class RunningMapViewModel: RunningMapViewModelInputs, RunningMapViewModelOutputs {
    private let runningService: RunningServiceType
    private var lastRouteIdx = 0

    init(runningService: RunningServiceType) {
        self.runningService = runningService
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // inputs
    func viewWillAppear() {
        userTrackingModeOnWithAnimatedSignal.send(false)
        appearAnimationSignal.send()
        guard
            !runningService.recordService.locations.isEmpty,
            lastRouteIdx + 1 < runningService.recordService.locations.count
        else { return }
        routesSubject.send(runningService.recordService.locations[lastRouteIdx...].map { $0.coordinate })
        lastRouteIdx = runningService.recordService.locations.count - 1
    }

    func viewWillDisappear() {
        userTrackingModeOffSignal.send()
        closeAnimationSignal.send()
    }

    func didTapLocateButton() {
        userTrackingModeOnWithAnimatedSignal.send(true)
    }

    func didTapExitButton() {
        closeSignal.send()
    }

    // outputs
    var routesSubject = PassthroughSubject<[CLLocationCoordinate2D], Never>()
    var userTrackingModeOnWithAnimatedSignal = PassthroughSubject<Bool, Never>()
    var userTrackingModeOffSignal = PassthroughSubject<Void, Never>()
    var closeSignal = PassthroughSubject<Void, Never>()
    var closeAnimationSignal = PassthroughSubject<Void, Never>()
    var appearAnimationSignal = PassthroughSubject<Void, Never>()
}

extension RunningMapViewModel: RunningMapViewModelTypes {
    var inputs: RunningMapViewModelInputs { self }
    var outputs: RunningMapViewModelOutputs { self }
}
