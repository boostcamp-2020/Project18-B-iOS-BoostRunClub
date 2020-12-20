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

    // Life Cycle
    func viewDidLoad()
    func viewDidAppear()
}

protocol ActivityDetailViewModelOutputs {
    var showInfoDetailSignal: PassthroughSubject<Void, Never> { get }
    var showRouteDetailSignal: PassthroughSubject<ActivityDetailConfig, Never> { get }
    var closeSignal: PassthroughSubject<Void, Never> { get }

    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never> { get }

    var initialAnimationSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityDetailViewModel: ActivityDetailViewModelInputs, ActivityDetailViewModelOutputs {
    private var initialAnimation = false

    init?(activity: Activity, detail: ActivityDetail?, activityService: ActivityReadable) {
        let detailConfig: ActivityDetailConfig
        if let detail = detail {
            detailConfig = ActivityDetailConfig(activity: activity, detail: detail)
        } else {
            guard let detail = activityService.fetchActivityDetail(activityId: activity.uuid) else { return nil }
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
        closeSignal.send()
    }

    func viewDidLoad() {}

    func viewDidAppear() {
        if !initialAnimation {
            initialAnimation = true
            initialAnimationSignal.send()
        }
    }

    // Outputs
    var initialAnimationSignal = PassthroughSubject<Void, Never>()

    var showInfoDetailSignal = PassthroughSubject<Void, Never>()
    var showRouteDetailSignal = PassthroughSubject<ActivityDetailConfig, Never>()
    var closeSignal = PassthroughSubject<Void, Never>()
    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never>
}

extension ActivityDetailViewModel: ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { self }
    var outputs: ActivityDetailViewModelOutputs { self }
}
