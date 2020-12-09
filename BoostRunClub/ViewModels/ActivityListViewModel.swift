//
//  ActivityListViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/09.
//

import Combine
import Foundation

protocol ActivityListViewModelTypes {
    var inputs: ActivityListViewModelInputs { get }
    var outputs: ActivityListViewModelOutputs { get }
}

protocol ActivityListViewModelInputs {
    func didTapBackItem()
}

protocol ActivityListViewModelOutputs {
    var goBackToSceneSignal: PassthroughSubject<Void, Never> { get }
}

class ActivityListViewModel: ActivityListViewModelInputs, ActivityListViewModelOutputs {
    let activityProvider: ActivityReadable

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider
    }

    // Inputs
    func didTapBackItem() {
        goBackToSceneSignal.send()
    }

    // Outputs
    var goBackToSceneSignal = PassthroughSubject<Void, Never>()
}

extension ActivityListViewModel: ActivityListViewModelTypes {
    var inputs: ActivityListViewModelInputs { self }
    var outputs: ActivityListViewModelOutputs { self }
}
