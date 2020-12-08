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
    var closeSheetSignal: PassthroughSubject<DateRange?, Never> { get }
}

class ActivityDateFilterViewModel: ActivityDateFilterViewModelInputs, ActivityDateFilterViewModelOutputs {
    private var filterType: ActivityFilterType
    private var dateRanges: [DateRange]

    init(filterType: ActivityFilterType, dateRanges: [DateRange]) {
        self.filterType = filterType
        self.dateRanges = dateRanges
    }

    // Inputs
    func didSelectDateFilter(selects _: [Int]) {
        closeSheetSignal.send(DateRange(start: Date(), end: Date()))
    }

    func didTapBackgroundView() {
        closeSheetSignal.send(DateRange(start: Date(), end: Date()))
    }

    // Outputs
    var closeSheetSignal = PassthroughSubject<DateRange?, Never>()
}

extension ActivityDateFilterViewModel: ActivityDateFilterViewModelTypes {
    var inputs: ActivityDateFilterViewModelInputs { self }
    var outputs: ActivityDateFilterViewModelOutputs { self }
}
