//
//  ActivityDetailViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import Foundation

import Combine

protocol ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { get }
    var outputs: ActivityDetailViewModelOutputs { get }
}

protocol ActivityDetailViewModelInputs {
    func didTapBackItem()
    func didTapShowRouteDetail()
    func didTapShowInfoDetail()
    func viewDidLoad()
    func viewDidAppear()
}

protocol ActivityDetailViewModelOutputs {
    var showInfoDetailSignal: PassthroughSubject<Void, Never> { get }
    var showRouteDetailSignal: PassthroughSubject<ActivityDetailConfig, Never> { get }
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never> { get }

    var initialAnimationSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityDetailViewModel: ActivityDetailViewModelInputs, ActivityDetailViewModelOutputs {
    init?(activity: Activity, detail: ActivityDetail?, activityProvider: ActivityReadable) {
        let detailConfig: ActivityDetailConfig
        if let detail = detail {
            detailConfig = ActivityDetailConfig(activity: activity, detail: detail)
        } else {
            guard let detail = activityProvider.fetchActivityDetail(activityId: activity.uuid) else { return nil }
            detailConfig = ActivityDetailConfig(activity: activity, detail: detail)
        }

        detailConfigSubject = CurrentValueSubject<ActivityDetailConfig, Never>(detailConfig)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs

    func didTapShowRouteDetail() {
        showRouteDetailSignal.send(detailConfigSubject.value)
    }

    func didTapShowInfoDetail() {
        showInfoDetailSignal.send()
    }

    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    func viewDidLoad() {}

    func viewDidAppear() {
        initialAnimationSignal.send()
    }

    // Outputs
    var initialAnimationSignal = PassthroughSubject<Void, Never>()

    var showInfoDetailSignal = PassthroughSubject<Void, Never>()
    var showRouteDetailSignal = PassthroughSubject<ActivityDetailConfig, Never>()
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never>
}

extension ActivityDetailViewModel: ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { self }
    var outputs: ActivityDetailViewModelOutputs { self }
}
