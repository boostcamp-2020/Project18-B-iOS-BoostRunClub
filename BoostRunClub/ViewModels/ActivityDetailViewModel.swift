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
}

protocol ActivityDetailViewModelOutputs {
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityDetailViewModel: ActivityDetailViewModelInputs, ActivityDetailViewModelOutputs {
    let activity: Activity
    let activityDetail: ActivityDetail

    init?(activity: Activity, activityProvider: ActivityReadable) {
        guard let detail = activityProvider.fetchActivityDetail(activityId: activity.uuid) else { return nil }
        self.activity = activity
        activityDetail = detail
    }

    // Inputs
    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    // Outputs
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
}

extension ActivityDetailViewModel: ActivityDetailViewModelTypes {
    var inputs: ActivityDetailViewModelInputs { self }
    var outputs: ActivityDetailViewModelOutputs { self }
}
