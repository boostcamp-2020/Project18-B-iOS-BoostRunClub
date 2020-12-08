//
//  ActivityDateFilterViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/08.
//

import Foundation

import Combine

protocol ActivityDateFilterViewModelTypes: AnyObject {
    var inputs: ActivityDateFilterViewModelInputs { get }
    var outputs: ActivityDateFilterViewModelOutputs { get }
}

protocol ActivityDateFilterViewModelInputs {
    func didSelectDateFilter(selects: [Int])
    func didTapBackgroundView()
}

protocol ActivityDateFilterViewModelOutputs {
    var closeSheetSignal: PassthroughSubject<(Date, Date), Never> { get }
}

class ActivityDateFilterViewModel: ActivityDateFilterViewModelInputs, ActivityDateFilterViewModelOutputs {
    var filterType: ActivityFilterType

    init(filterType: ActivityFilterType, activityProvider _: ActivityWritable) {
        self.filterType = filterType
    }

    // Inputs
    func didSelectDateFilter(selects _: [Int]) {
        closeSheetSignal.send((Date(), Date()))
    }

    func didTapBackgroundView() {
        closeSheetSignal.send((Date(), Date()))
    }

    // Outputs
    var closeSheetSignal = PassthroughSubject<(Date, Date), Never>()
}

extension ActivityDateFilterViewModel: ActivityDateFilterViewModelTypes {
    var inputs: ActivityDateFilterViewModelInputs { self }
    var outputs: ActivityDateFilterViewModelOutputs { self }
}
