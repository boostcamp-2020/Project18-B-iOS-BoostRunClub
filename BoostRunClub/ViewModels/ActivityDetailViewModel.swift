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
}

protocol ActivityDetailViewModelOutputs {
    var showInfoDetailSignal: PassthroughSubject<Void, Never> { get }
    var showRouteDetailSignal: PassthroughSubject<Void, Never> { get }
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never> { get }
}

class ActivityDetailViewModel: ActivityDetailViewModelInputs, ActivityDetailViewModelOutputs {
    init?(activity: Activity, activityProvider: ActivityReadable) {
        guard let detail = activityProvider.fetchActivityDetail(activityId: activity.uuid) else { return nil }

        let detailConfig = ActivityDetailConfig(activity: activity, detail: detail)
        detailConfigSubject = CurrentValueSubject<ActivityDetailConfig, Never>(detailConfig)
    }

    // Inputs

    func didTapShowRouteDetail() {
        showRouteDetailSignal.send()
    }

    func didTapShowInfoDetail() {
        showInfoDetailSignal.send()
    }

    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    func viewDidLoad() {}

    // Outputs

    var showInfoDetailSignal = PassthroughSubject<Void, Never>()
    var showRouteDetailSignal = PassthroughSubject<Void, Never>()
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
    var detailConfigSubject: CurrentValueSubject<ActivityDetailConfig, Never>
}

extension ActivityDetailViewModel: ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { self }
    var outputs: ActivityDetailViewModelOutputs { self }
}
