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
    func didTapSelectButton()
    func didTapBackgroundView()
    func didPickerChanged(row: Int, component: Int)
}

protocol ActivityDateFilterViewModelOutputs {
    typealias PickerMover = (component: Int, row: Int)

    var pickerListSubject: CurrentValueSubject<[[String]], Never> { get }

    var adjustPickerSignal: PassthroughSubject<PickerMover, Never> { get }
    var closeSheetSignal: PassthroughSubject<DateRange?, Never> { get }
}

class ActivityDateFilterViewModel: ActivityDateFilterViewModelInputs, ActivityDateFilterViewModelOutputs {
    private var filterType: ActivityFilterType
    private var dateRanges = [[DateRange?]]()
    private var selectedRow = [Int](repeating: 0, count: 2)

    init(filterType: ActivityFilterType, dateRanges: [DateRange]) {
        self.filterType = filterType
        configurePickerList(filterType: filterType, ranges: dateRanges)
    }

    // Inputs
    func didPickerChanged(row: Int, component: Int) {
        switch filterType {
        case .all, .week, .year:
            selectedRow[1] = row
        case .month:
            if component == 0 {
                selectedRow[0] = row
            } else {
                selectedRow[1] = row
                if dateRanges[selectedRow[0]][row] == nil {
                    adjustPicker(component: component, componentRow: selectedRow[0])
                }
            }
        }
    }

    func didTapSelectButton() {
        let dateRange = dateRanges[selectedRow[0]][selectedRow[1]]
        closeSheetSignal.send(dateRange)
    }

    func didTapBackgroundView() {
        closeSheetSignal.send(nil)
    }

    // Outputs
    var pickerListSubject = CurrentValueSubject<[[String]], Never>([])

    var closeSheetSignal = PassthroughSubject<DateRange?, Never>()
    var adjustPickerSignal = PassthroughSubject<PickerMover, Never>()
}

extension ActivityDateFilterViewModel: ActivityDateFilterViewModelTypes {
    var inputs: ActivityDateFilterViewModelInputs { self }
    var outputs: ActivityDateFilterViewModelOutputs { self }
}

// MARK: - private function

extension ActivityDateFilterViewModel {
    private func configurePickerList(filterType: ActivityFilterType, ranges: [DateRange]) {
        var pickerList: [[String]]

        switch filterType {
        case .all:
            dateRanges = []
            pickerList = []

        case .week:
            dateRanges = [[]]
            pickerList = [[]]

            ranges.forEach {
                self.dateRanges[0].append($0)
                pickerList[0].append($0.start.toMDString + "~" + $0.end.toMDString)
            }
        case .year:
            dateRanges = [[]]
            pickerList = [[]]

            ranges.forEach {
                self.dateRanges[0].append($0)
                pickerList[0].append($0.start.toYString)
            }
        case .month:
            dateRanges = []
            pickerList = [[], ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]]
            var monthTable = [Int: [(month: Int, range: DateRange)]]()
            ranges.forEach {
                guard let dateComponent = $0.start.yearMonthDay else { return }
                let key = dateComponent.year
                var list = monthTable[key, default: []]
                list.append((month: Int(dateComponent.month), range: $0))
                monthTable[key] = list
            }

            let sortedTable = monthTable.sorted(by: { $0.key < $1.key })
            for (idx, elements) in sortedTable.enumerated() {
                pickerList[0].append("\(elements.key)년")
                dateRanges.append([DateRange?](repeating: nil, count: 12))
                elements.value.forEach {
                    print($0.month)
                    dateRanges[idx][$0.month - 1] = $0.range
                }
            }
        }
        pickerListSubject.send(pickerList)
    }

    private func adjustPicker(component: Int, componentRow: Int) {
        guard let index = dateRanges[componentRow].firstIndex(where: { $0 != nil }) else { return }
        selectedRow[component] = index
        adjustPickerSignal.send((component: component, row: index))
    }
}
