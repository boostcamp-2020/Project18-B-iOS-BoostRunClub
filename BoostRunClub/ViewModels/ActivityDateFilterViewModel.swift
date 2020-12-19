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

    // Life Cycle
    func viewDidLoad()
}

protocol ActivityDateFilterViewModelOutputs {
    typealias PickerMover = (component: Int, row: Int, animate: Bool)
    // Data For Configure
    var pickerListSubject: CurrentValueSubject<[[String]], Never> { get }

    // Signal For View Action
    var adjustPickerSignal: PassthroughSubject<PickerMover, Never> { get }

    // Signal For Coordinate
    var closeSignal: PassthroughSubject<DateRange?, Never> { get }
}

class ActivityDateFilterViewModel: ActivityDateFilterViewModelInputs, ActivityDateFilterViewModelOutputs {
    private var filterType: ActivityFilterType
    private var dateRanges = [[DateRange?]]()
    private var selectedRow = [Int](repeating: 0, count: 2)

    init(filterType: ActivityFilterType, dateRanges: [DateRange], currentRange: DateRange) {
        self.filterType = filterType
        configurePickerList(filterType: filterType, ranges: dateRanges, currentRange: currentRange)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs
    func viewDidLoad() {
        switch filterType {
        case .all, .week, .year:
            adjustPickerSignal.send((component: 0, row: selectedRow[0], animate: false))
        case .month:
            adjustPickerSignal.send((component: 0, row: selectedRow[0], animate: false))
            adjustPickerSignal.send((component: 1, row: selectedRow[1], animate: false))
        }
    }

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
        let dateRange: DateRange?
        switch filterType {
        case .all, .week, .year:
            dateRange = dateRanges[0][selectedRow[1]]
        case .month:
            dateRange = dateRanges[selectedRow[0]][selectedRow[1]]
        }
        closeSignal.send(dateRange)
    }

    func didTapBackgroundView() {
        closeSignal.send(nil)
    }

    // Outputs
    var pickerListSubject = CurrentValueSubject<[[String]], Never>([])

    var closeSignal = PassthroughSubject<DateRange?, Never>()
    var adjustPickerSignal = PassthroughSubject<PickerMover, Never>()
}

extension ActivityDateFilterViewModel: ActivityDateFilterViewModelTypes {
    var inputs: ActivityDateFilterViewModelInputs { self }
    var outputs: ActivityDateFilterViewModelOutputs { self }
}

// MARK: - private function

extension ActivityDateFilterViewModel {
    private func configurePickerList(
        filterType: ActivityFilterType,
        ranges: [DateRange],
        currentRange: DateRange
    ) {
        var pickerList: [[String]]
        switch filterType {
        case .all:
            dateRanges = []
            pickerList = []
        case .week, .year:
            dateRanges = [[]]
            pickerList = [[]]

            for (idx, range) in ranges.enumerated() {
                dateRanges[0].append(range)
                pickerList[0].append(filterType.rangeDescription(at: range))
                if range == currentRange {
                    selectedRow[0] = idx
                }
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
            for (sectionIndex, elements) in sortedTable.enumerated() {
                pickerList[0].append("\(elements.key)년")
                dateRanges.append([DateRange?](repeating: nil, count: 12))
                elements.value.forEach {
                    dateRanges[sectionIndex][$0.month - 1] = $0.range
                    if $0.range == currentRange {
                        selectedRow[0] = sectionIndex
                        selectedRow[1] = $0.month - 1
                    }
                }
            }
        }
        pickerListSubject.send(pickerList)
    }

    private func adjustPicker(component: Int, componentRow: Int) {
        guard let index = dateRanges[componentRow].firstIndex(where: { $0 != nil }) else { return }
        selectedRow[component] = index
        adjustPickerSignal.send((component: component, row: index, animate: true))
    }
}
