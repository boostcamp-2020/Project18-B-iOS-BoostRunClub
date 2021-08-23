//
//  RunningRecoder.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreLocation
import Foundation

final class RunningRecordService: RunningRecordServiceable {
    private var cancellables = Set<AnyCancellable>()
    private let activityWriter: ActivityWritable
    private let mapSnapShotter: RunningSnapShotProvider

    private(set) var locations = [CLLocation]()
    private(set) var runningSplits = [RunningSplit]()
    private(set) var currentSplit = RunningSplit()
    private(set) var currentSlice = RunningSlice()

    private(set) var maxAltitude: Double = 0
    private(set) var minAltitude: Double = 0

    private(set) var states = [RunningState]()
    private var paceDelta: Int = 1

    var routes: [RunningSlice] {
        currentSlice.endIndex = locations.count - 1
        currentSlice.isRunning = states.last?.isRunning ?? true
        return runningSplits.flatMap { $0.runningSlices } + currentSplit.runningSlices + [currentSlice]
    }

    private(set) var didAddSplitSignal = PassthroughSubject<RunningSplit, Never>()

    init(activityWriter: ActivityWritable, mapSnapShotter: RunningSnapShotProvider) {
        self.activityWriter = activityWriter
        self.mapSnapShotter = mapSnapShotter
    }

    func clear() {
        maxAltitude = 0
        minAltitude = 0
        locations.removeAll()
        states.removeAll()
        runningSplits.removeAll()
        currentSplit = RunningSplit()
        currentSlice = RunningSlice()
    }

    func addState(_ state: RunningState) {
        print("[RECORDER] states: \(states.count) locations: \(locations.count)")

        guard let recentState = states.last else {
            states.append(state)
            locations.append(state.location)
            maxAltitude = state.location.altitude
            minAltitude = state.location.altitude
            return
        }

        maxAltitude = max(maxAltitude, state.location.altitude)
        minAltitude = min(minAltitude, state.location.altitude)

        if Int(state.distance / 1000) > Int(recentState.distance / 1000) {
            addSlice()
            addSplit()
        }

        // isRunning -> true -> false or false -> true
        if recentState.isRunning != state.isRunning {
            addSlice()
        }

        // 페이스 증가/감소 여부에 따라 Slice 분리
        let newPaceDelta = state.pace - recentState.pace
        if newPaceDelta * paceDelta < 0 {
            paceDelta = newPaceDelta
            addSlice()
        }

        states.append(state)
        locations.append(state.location)
    }

    private func addSlice() {
        guard
            // 조건 1: state가 존재해야 한다.
            let state = states.last,
            // 조건 2: locations 배열이 비어있지 않아야 한다.
            !locations.isEmpty,
            // 조건 3: slice의 구성원소가 1개 이상이어야 한다.
            currentSlice.startIndex != locations.count - 1
        else { return }

        currentSlice.endIndex = locations.count - 1
        currentSlice.isRunning = state.isRunning
        currentSlice.setupSlice(with: states)
        currentSplit.runningSlices.append(currentSlice)

        // swiftlint:disable:next line_length
        print("[RECORDER] addSlice (\(currentSlice.startIndex)-\(currentSlice.endIndex)) run: \(currentSlice.isRunning) paceD: \(states[currentSlice.startIndex].pace - states[currentSlice.endIndex].pace) ")

        currentSlice = RunningSlice()
        currentSlice.startIndex = locations.count - 1
    }

    private func addSplit() {
        currentSplit.setup(with: states)
        runningSplits.append(currentSplit)
        didAddSplitSignal.send(currentSplit)
        currentSplit = RunningSplit()
    }

    func save(startTime: Date?, endTime: Date?) -> (activity: Activity, detail: ActivityDetail)? {
        guard
            let lastState = states.last,
            let startTime = startTime,
            let endTime = endTime
        else { return nil }
        addSlice()
        addSplit()

        let uuid = UUID()

        let elevation = maxAltitude - minAltitude

        var activity = Activity(
            avgPace: lastState.avgPace,
            distance: lastState.distance,
            duration: lastState.runningTime,
            elevation: elevation,
            thumbnail: nil,
            createdAt: startTime,
            finishedAt: endTime,
            uuid: uuid
        )

        let detail = ActivityDetail(
            activityUUID: uuid,
            avgBPM: 0,
            cadence: lastState.cadence,
            calorie: Int(lastState.calorie),
            elevation: Int(elevation),
            locations: locations.map { Location(clLocation: $0) },
            splits: runningSplits
        )
        print("[Recorder] splits \(runningSplits.count)")

        mapSnapShotter.takeSnapShot(from: locations, dimension: 100)
            .receive(on: RunLoop.main)
            .replaceError(with: nil)
            .sink { [weak self] data in
                activity.thumbnail = data
                self?.activityWriter.addActivity(activity: activity, activityDetail: detail)
            }
            .store(in: &cancellables)

        return (activity, detail)
    }
}
