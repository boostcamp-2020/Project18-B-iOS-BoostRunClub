//
//  RunningRecoder.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/16.
//

import Combine
import CoreLocation
import Foundation

protocol RunningRecodable {
    func addState(_ state: RunningState)
    func save(startTime: Date?, endTime: Date?) -> (activity: Activity, detail: ActivityDetail)?

    var locations: [CLLocation] { get }
    var routes: [RunningSlice] { get }
    var newSplitSubject: PassthroughSubject<RunningSplit, Never> { get }
}

class RunningRecoder: RunningRecodable {
    private var cancellables = Set<AnyCancellable>()
    let activityWriter: ActivityWritable
    let mapSnapShotter: MapSnapShotService

    private(set) var locations = [CLLocation]()
    private(set) var runningSplits = [RunningSplit]()
    private(set) var currentSplit = RunningSplit()
    private(set) var currentSlice = RunningSlice()

    private(set) var maxAltitude: Double = 0
    private(set) var minAltitude: Double = 0

    private(set) var states = [RunningState]()

    var routes: [RunningSlice] {
        runningSplits.flatMap { $0.runningSlices } + currentSplit.runningSlices + [currentSlice]
    }

    private(set) var newSplitSubject = PassthroughSubject<RunningSplit, Never>()

    init(activityWriter: ActivityWritable, mapSnapShotter: MapSnapShotService) {
        self.activityWriter = activityWriter
        self.mapSnapShotter = mapSnapShotter
    }

    func addState(_ state: RunningState) {
        guard let recentState = states.last else {
            states.append(state)
            locations.append(state.location)
            maxAltitude = state.location.altitude
            minAltitude = state.location.altitude
            return
        }

        maxAltitude = max(maxAltitude, state.location.altitude)
        minAltitude = min(minAltitude, state.location.altitude)

        // isRunning -> true -> false or false -> true
        if recentState.isRunning != state.isRunning {
            addSlice()
        }

        // 1KM
        if Int(state.distance / 1000) > Int(recentState.distance / 1000) {
            let currentP = state.location.coordinate
            let prevP = recentState.location.coordinate
            let remainDistance = Double(1000 - Int(recentState.distance) % 1000)

            let newPoint = currentP.locationToDest(dest: prevP, distanceMeters: remainDistance)
            let newLocation = CLLocation(latitude: newPoint.latitude, longitude: newPoint.longitude)
            let newState = RunningState(
                location: newLocation,
                runningTime: state.runningTime,
                calorie: state.calorie,
                pace: state.pace,
                avgPace: state.avgPace,
                cadence: state.cadence,
                distance: recentState.distance + remainDistance,
                isRunning: state.isRunning
            )

            locations.append(newLocation)
            addSlice()
            addSplit()

            states.append(newState)
        }

        states.append(state)
        locations.append(state.location)
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
            calorie: lastState.calorie,
            elevation: Int(elevation),
            locations: locations.map { Location(clLocation: $0) },
            splits: runningSplits
        )

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

    func addSlice() {
        guard
            let state = states.last,
            !locations.isEmpty
        else { return }

        currentSlice.endIndex = locations.count - 1
        currentSlice.isRunning = state.isRunning
        currentSlice.setupSlice(with: locations)
        currentSplit.runningSlices.append(currentSlice)

        currentSlice = RunningSlice()
        currentSlice.startIndex = locations.count - 1
    }

    func addSplit() {
        currentSplit.setup(with: states)
        runningSplits.append(currentSplit)
        newSplitSubject.send(currentSplit)
        currentSplit = RunningSplit()
    }
}
