//
//  ActivityViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

import Combine

protocol ActivityViewModelTypes: AnyObject {
    var inputs: ActivityViewModelInputs { get }
    var outputs: ActivityViewModelOutputs { get }
}

protocol ActivityViewModelInputs {
    func didFilterChanged(to idx: Int)
    func didFilterRangeChanged(from startDate: Date, to endDate: Date)
    func didSelectActivity(at index: Int)
    func didTapShowDateFilter()
    func didTapShowAllActivities()
    func didTapShowProfileButton()
}

protocol ActivityViewModelOutputs {
    var activityTotal: CurrentValueSubject<ActivityTotalConfig, Never> { get }
    var activityStatistic: CurrentValueSubject<ActivityStatisticConfig, Never> { get }
    var activitiesSubject: CurrentValueSubject<[Activity], Never> { get }

    var showStatisticSignal: PassthroughSubject<ActivityStatisticConfig?, Never> { get }
    var showProfileScene: PassthroughSubject<Void, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider
    }

    // Inputs
    func didFilterChanged(to _: Int) {}
    func didFilterRangeChanged(from _: Date, to _: Date) {}
    func didSelectActivity(at _: Int) {}
    func didTapShowAllActivities() {}
    func didTapShowProfileButton() {}
    func didTapShowDateFilter() {}

    // Outputs
    var activityTotal = CurrentValueSubject<ActivityTotalConfig, Never>(ActivityTotalConfig())
    var activityStatistic = CurrentValueSubject<ActivityStatisticConfig, Never>(ActivityStatisticConfig())
    var activitiesSubject = CurrentValueSubject<[Activity], Never>([])

    var showStatisticSignal = PassthroughSubject<ActivityStatisticConfig?, Never>()
    var showProfileScene = PassthroughSubject<Void, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}
