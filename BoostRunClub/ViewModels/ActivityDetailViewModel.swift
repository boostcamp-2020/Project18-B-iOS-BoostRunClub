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
    func viewDidLoad()
}

protocol ActivityDetailViewModelOutputs {
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityDetailViewModel: ActivityDetailViewModelInputs, ActivityDetailViewModelOutputs {
    let detailConfig: ActivityDetailConfig

    init?(activity: Activity, activityProvider: ActivityReadable) {
        guard let detail = activityProvider.fetchActivityDetail(activityId: activity.uuid) else { return nil }
        detailConfig = ActivityDetailConfig(activity: activity, detail: detail)
    }

    // Inputs
    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    func viewDidLoad() {}

    // Outputs
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
}

extension ActivityDetailViewModel: ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { self }
    var outputs: ActivityDetailViewModelOutputs { self }
}
