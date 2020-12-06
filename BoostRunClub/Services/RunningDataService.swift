//
//  RunningDataService.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/01.
//

import Combine
import CoreLocation
import Foundation

protocol RunningDataServiceable {
    var runningTime: CurrentValueSubject<TimeInterval, Never> { get }
    var distance: CurrentValueSubject<Double, Never> { get }
    var pace: CurrentValueSubject<Int, Never> { get }
    var avgPace: CurrentValueSubject<Int, Never> { get }
    var isRunning: Bool { get }
    var currentLocation: PassthroughSubject<CLLocationCoordinate2D, Never> { get }
    var locations: [CLLocation] { get }
    var runningSplits: [RunningSplit] { get }
    var currentRunningSlice: RunningSlice { get }
    var routes: [RunningSlice] { get }
    func start()
    func stop()
    func pause()
    func resume()
}

class RunningDataService: RunningDataServiceable {
    var locationProvider: LocationProvidable
    var activityWriter: ActivityWritable

    var cancellables = Set<AnyCancellable>()
    var locations = [CLLocation]()

    var startTime = Date()
    var endTime = Date()
    var lastUpdatedTime: TimeInterval = 0

    var currentLocation = PassthroughSubject<CLLocationCoordinate2D, Never>()
    var runningTime = CurrentValueSubject<TimeInterval, Never>(0)
    var pace = CurrentValueSubject<Int, Never>(0)
    var avgPace = CurrentValueSubject<Int, Never>(0)
    var distance = CurrentValueSubject<Double, Never>(0)

    var runningSplits = [RunningSplit]()
    var currentRunningSplit = RunningSplit()
    var currentRunningSlice = RunningSlice()
    var routes: [RunningSlice] {
        runningSplits.flatMap { $0.runningSlices } + currentRunningSplit.runningSlices + [currentRunningSlice]
    }

    private(set) var isRunning: Bool = false
    let eventTimer: EventTimerProtocol

    init(eventTimer: EventTimerProtocol = EventTimer(),
         locationProvider: LocationProvidable,
         activityWriter: ActivityWritable)
    {
        self.eventTimer = eventTimer
        self.locationProvider = locationProvider
        self.activityWriter = activityWriter

        locationProvider.locationSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.updateLocation(location: location)
                self.updateTime(currentTime: location.timestamp.timeIntervalSinceReferenceDate)
            }
            .store(in: &cancellables)

        eventTimer.timeSubject
            .sink { [weak self] time in
                self?.updateTime(currentTime: time)
            }
            .store(in: &cancellables)
    }

    func initializeRunningData() {
        startTime = Date()
        lastUpdatedTime = Date.timeIntervalSinceReferenceDate
        runningTime.value = 0
        pace.value = 0
        avgPace.value = 0
        distance.value = 0
        locations.removeAll()
        currentRunningSlice = RunningSlice()
        currentRunningSplit = RunningSplit()
        runningSplits.removeAll()
    }

    func start() {
        if !isRunning {
            isRunning = true
            eventTimer.start()
            locationProvider.startBackgroundTask()
            initializeRunningData()
        }
        //		addSplit()
    }

    func stop() {
        addSplit()
        locationProvider.stopBackgroundTask()
        eventTimer.stop()
        endTime = Date()
        let uuid = UUID()
        let activity = Activity(avgPace: avgPace.value, distance: distance.value, duration: runningTime.value, thumbnail: nil, createdAt: startTime, uuid: uuid)
        let activityDetail = ActivityDetail(activityUUID: uuid, avgBPM: 0, cadence: 0, calorie: 0, elevation: 0, locations: [])
        activityWriter.addActivity(activity: activity, activityDetail: activityDetail)

        isRunning = false
    }

    func pause() {
        addSlice()
        isRunning = false
    }

    func resume() {
        addSlice()
        isRunning = true
    }

    func addSlice() {
        if locations.isEmpty { return }
        currentRunningSlice.isRunning = isRunning
        currentRunningSlice.endIndex = locations.count - 1
        currentRunningSplit.runningSlices.append(currentRunningSlice)

        currentRunningSlice = RunningSlice()
        currentRunningSlice.startIndex = locations.count - 1
    }

    func addSplit() {
        addSlice()
        runningSplits.append(currentRunningSplit)

        currentRunningSplit = RunningSplit()
    }

    func updateTime(currentTime: TimeInterval) {
        if isRunning {
            runningTime.value += currentTime - lastUpdatedTime
        }
        lastUpdatedTime = currentTime
    }

    func updateLocation(location: CLLocation) {
        currentLocation.send(location.coordinate)

        if isRunning, let prevLocation = locations.last {
            let newDistance = location.distance(from: prevLocation) + distance.value
            if Int(newDistance / 1000) - Int(distance.value / 1000) > 0 {
                addSplit()
            }
            distance.value = newDistance
        }

        let paceDouble = 1000 / location.speed
        if !(paceDouble.isNaN || paceDouble.isInfinite) {
            pace.value = Int(paceDouble)
        }

        locations.append(location)
        avgPace.value = (avgPace.value * (locations.count - 1) + pace.value) / locations.count
    }
}

// struct RunningSlice {
//    var startIndex: Int
//    var endIndex: Int
//    var distance: Double
// }
