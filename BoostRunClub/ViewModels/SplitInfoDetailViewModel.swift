//
//  SplitInfoDetailViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/14.
//

import Combine
import Foundation

protocol SplitInfoDetailViewModelType {
    var inputs: SplitInfoDetailViewModelInputs { get }
    var outputs: SplitInfoDetailViewModelOutputs { get }
}

protocol SplitInfoDetailViewModelInputs {
    func didTapbackButton()
}

protocol SplitInfoDetailViewModelOutputs {
    typealias DateType = (date: String, time: String)
    var splitInfoSubject: CurrentValueSubject<[SplitInfo], Never> { get }
    var splitSubject: CurrentValueSubject<[SplitRow], Never> { get }
    var dateSubject: CurrentValueSubject<DateType, Never> { get }
}

class SplitInfoDetailViewModel: SplitInfoDetailViewModelInputs, SplitInfoDetailViewModelOutputs {
    let activity: Activity
    var activityDetail: ActivityDetail

    init?(activity: Activity, activityProvider: ActivityReadable) {
        guard let activityDetail = activityProvider.fetchActivityDetail(activityId: activity.uuid) else { return nil }

        self.activity = activity
        self.activityDetail = activityDetail
        self.activityDetail.splits = activityDetail.splits.sorted { (first, second) -> Bool in
            first.runningSlices[0].startIndex < second.runningSlices[0].startIndex
        }

        dateSubject.value = makeDateInfo()
        splitInfoSubject.value = makeSplitInfo()
        splitSubject.value = makeSplitRows()
    }

    func didTapbackButton() {}

    var splitInfoSubject = CurrentValueSubject<[SplitInfo], Never>([])
    var splitSubject = CurrentValueSubject<[SplitRow], Never>([])
    var dateSubject = CurrentValueSubject<DateType, Never>(("", ""))

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension SplitInfoDetailViewModel: SplitInfoDetailViewModelType {
    var inputs: SplitInfoDetailViewModelInputs { self }
    var outputs: SplitInfoDetailViewModelOutputs { self }
}

// MARK: - Data Transform

extension SplitInfoDetailViewModel {
    func makeDateInfo() -> DateType {
        let start = activity.createdAt
        let end = activity.finishedAt
        return (start.toMDEString, start.toPHM + " - " + end.toPHM)
    }

    func makeSplitInfo() -> [SplitInfo] {
        var splitInfo: [SplitInfo] = [
            SplitInfo(title: "거리", value: "\(distText) km"),
            SplitInfo(title: "평균 페이스", value: "\(avgPaceText) /km"),
            SplitInfo(title: "최고 페이스", value: "\(maxPaceText) /km"),
            SplitInfo(title: "러닝 시간", value: activity.duration.fullFormattedString),
            SplitInfo(title: "경과 시간", value: activity.duration.fullFormattedString),
            SplitInfo(title: "칼로리(근사치)", value: "\(activityDetail.calorie) kcal"),
            SplitInfo(title: "평균 케이던스", value: "\(activityDetail.cadence) spm"),
            SplitInfo(title: "고도 상승", value: "-- m"),
            SplitInfo(title: "고도 하강", value: "-- m"),
        ]

        return splitInfo
    }

    func makeSplitRows() -> [SplitRow] {
        if activityDetail.splits.isEmpty { return [] }
        return (0 ..< activityDetail.splits.count).map {
            makeSplitRow(idx: $0, splits: activityDetail.splits)
        }
        // 더미 데이터
//        let splits = RunningSplit.sampleData
//        return (0 ..< splits.count).map { makeSplitRow(idx: $0, splits: splits) }
    }

    func makeSplitRow(idx: Int, splits: [RunningSplit]) -> SplitRow {
        let tmp = splits[idx].distance
        let kilometer: String
        if idx == splits.count - 1, tmp != 1000 {
            kilometer = distanceToText(tmp)
        } else {
            kilometer = (idx + 1).description
        }

        let valueChange: ValueChange?
        if idx == 0 {
            valueChange = nil
        } else {
            let prevPace = splits[idx - 1].avgPace
            let currPace = splits[idx].avgPace
            let status: ValueChange.Status
            if prevPace == currPace {
                status = .equal
            } else if prevPace < currPace {
                status = .incresed
            } else {
                status = .decreased
            }

            valueChange = ValueChange(
                status: status,
                value: abs(currPace - prevPace).formattedString
            )
        }

        let elevation = "--"

        return SplitRow(
            kilometer: kilometer,
            avgPace: paceToText(splits[idx].avgPace),
            change: valueChange,
            elevation: "\(elevation) m"
        )
    }
}

extension SplitInfoDetailViewModel {
    var distText: String {
        distanceToText(activity.distance)
    }

    func distanceToText(_ distance: Double) -> String {
        String(format: "%.2f", distance / 1000)
    }

    func paceToText(_ pace: Int) -> String {
        String(format: "%d'%d\"", pace / 60, pace % 60)
    }

    var avgPaceText: String {
        paceToText(activity.avgPace)
    }

    var maxPaceText: String {
        paceToText(activityDetail.splits.map { $0.avgPace }.max() ?? 0)
    }
}
