//
//  RunningInfoViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/11/25.
//

import Combine
import Foundation

protocol RunningInfoViewModelTypes: AnyObject {
    var inputs: RunningInfoViewModelInputs { get }
    var outputs: RunningInfoViewModelOutputs { get }
}

protocol RunningInfoViewModelInputs {
    func didTapPauseButton()
    func didTapRunData(index: Int)

    // Life Cycle
    func viewDidAppear()
}

protocol RunningInfoViewModelOutputs {
    typealias RunningInfoTypeSubject = CurrentValueSubject<RunningInfo, Never>
    // Data For Configure
    var runningInfoSubjects: [RunningInfoTypeSubject] { get }

    // Signal For View Action
    var runningInfoTapAnimationSignal: PassthroughSubject<Int, Never> { get }
    var initialAnimationSignal: PassthroughSubject<Void, Never> { get }
    var resumeAnimationSignal: PassthroughSubject<Void, Never> { get }

    // Signal For Coordinate
    var showPausedRunningSignal: PassthroughSubject<Void, Never> { get }
}

class RunningInfoViewModel: RunningInfoViewModelInputs, RunningInfoViewModelOutputs {
    private var cancellables = Set<AnyCancellable>()

    private var possibleTypes: [RunningInfoType: String]
    let runningService: RunningServiceType

    var isResumed: Bool
    init(runningService: RunningServiceType, resumed: Bool) {
        isResumed = resumed
        possibleTypes = RunningInfoType.getPossibleTypes(from: .none)
            .reduce(into: [:]) { $0[$1] = $1.initialValue }

        self.runningService = runningService

        runningService.dashBoardService.runningStateSubject
            .sink { [weak self] data in
                self?.runningInfoSubjects.forEach {
                    let value: String
                    switch $0.value.type {
                    case .kilometer:
                        value = String(format: "%.2f", data.distance / 1000)
                    case .pace:
                        value = String(format: "%d'%d\"", data.pace / 60, data.pace % 60)
                    case .averagePace:
                        value = String(format: "%d'%d\"", data.avgPace / 60, data.avgPace % 60)
                    case .calorie:
                        value = data.calorie <= 0 ? "--" : String(data.calorie)
                    case .cadence:
                        value = data.cadence <= 0 ? "--" : String(data.cadence)
                    case .time, .interval, .bpm, .meter:
                        return
                    }
                    $0.send(RunningInfo(type: $0.value.type, value: value))
                }
            }
            .store(in: &cancellables)

        runningService.dashBoardService.runningTime
            .map { $0.simpleFormattedString }
            .sink { [weak self] timeString in
                self?.possibleTypes[.time] = timeString

                self?.runningInfoSubjects.forEach {
                    if $0.value.type == .time {
                        $0.send(RunningInfo(type: .time, value: timeString))
                    }
                }
            }.store(in: &cancellables)

        runningService.runningStateSubject
            .sink { [weak self] currentMotionType in
                if currentMotionType == .standing {
                    self?.showPausedRunningSignal.send()
                    runningService.pause(autoResume: true)
                }
            }.store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // MARK: Inputs

    func didTapPauseButton() {
        showPausedRunningSignal.send()
        runningService.pause(autoResume: false)
    }

    func didTapRunData(index: Int) {
        var nextType = runningInfoSubjects[index].value.type.circularNext()
        nextType = possibleTypes[nextType] != nil ? nextType : RunningInfoType.allCases[0]
        runningInfoSubjects[index].send(
            RunningInfo(
                type: nextType,
                value: possibleTypes[nextType, default: nextType.initialValue]
            )
        )
        runningInfoTapAnimationSignal.send(index)
    }

    func viewDidAppear() {
        if !runningService.isStarted {
            runningService.start()
            initialAnimationSignal.send()
        }

        if isResumed {
            resumeAnimationSignal.send()
        }
    }

    // MARK: Outputs

    var runningInfoSubjects = [
        RunningInfoTypeSubject(RunningInfo(type: .time)),
        RunningInfoTypeSubject(RunningInfo(type: .pace)),
        RunningInfoTypeSubject(RunningInfo(type: .averagePace)),
        RunningInfoTypeSubject(RunningInfo(type: .kilometer)),
    ]
    var runningInfoTapAnimationSignal = PassthroughSubject<Int, Never>()
    var initialAnimationSignal = PassthroughSubject<Void, Never>()
    var resumeAnimationSignal = PassthroughSubject<Void, Never>()
    var showPausedRunningSignal = PassthroughSubject<Void, Never>()
}

// MARK: - Types

extension RunningInfoViewModel: RunningInfoViewModelTypes {
    var inputs: RunningInfoViewModelInputs { self }
    var outputs: RunningInfoViewModelOutputs { self }
}
