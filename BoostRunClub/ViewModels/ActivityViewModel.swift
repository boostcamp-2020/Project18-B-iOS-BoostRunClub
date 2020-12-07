//
//  ActivityViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/07.
//

import Foundation

import Combine

protocol ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { get }
    var outputs: ActivityViewModelOutputs { get }
}

protocol ActivityViewModelInputs {
    func didFilterChanged(to type: ActivityFilter)
    func didFilterRangeChanged(from startDate: Date, to endDate: Date)
    func didSelectActivity(at index: Int)
    func didTapShowAllActivities()
    func didTapShowProfileButton()
}

protocol ActivityViewModelOutputs {
    var activityTotal: CurrentValueSubject<ActivityTotal, Never> { get }
    var activityStatistic: CurrentValueSubject<ActivityStatistic, Never> { get }
    var activitiesSubject: CurrentValueSubject<[Activity], Never> { get }

    var showStatisticSignal: PassthroughSubject<ActivityStatistic?, Never> { get }
    var showProfileScene: PassthroughSubject<Void, Never> { get }
}

class ActivityViewModel: ActivityViewModelInputs, ActivityViewModelOutputs {
    let activityProvider: ActivityReadable

    init(activityProvider: ActivityReadable) {
        self.activityProvider = activityProvider
    }

    // Inputs
    func didFilterChanged(to _: ActivityFilter) {}
    func didFilterRangeChanged(from _: Date, to _: Date) {}
    func didSelectActivity(at _: Int) {}
    func didTapShowAllActivities() {}
    func didTapShowProfileButton() {}

    // Outputs
    var activityTotal = CurrentValueSubject<ActivityTotal, Never>(ActivityTotal())
    var activityStatistic = CurrentValueSubject<ActivityStatistic, Never>(ActivityStatistic())
    var activitiesSubject = CurrentValueSubject<[Activity], Never>([])

    var showStatisticSignal = PassthroughSubject<ActivityStatistic?, Never>()
    var showProfileScene = PassthroughSubject<Void, Never>()
}

extension ActivityViewModel: ActivityViewModelTypes {
    var inputs: ActivityViewModelInputs { self }
    var outputs: ActivityViewModelOutputs { self }
}
