//
//  RunningPageViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/02.
//

import Combine
import Foundation

protocol RunningPageViewModelTypes {
    var inputs: RunningPageViewModelInputs { get }
    var outputs: RunningPageViewModelOutputs { get }
}

protocol RunningPageViewModelInputs {
    func scrollViewWillBeginDragging()
    func scrollViewDidEndDragging()
    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double)
    func currentPageDidChange(idx: Int)
    func didScrollScreen()
}

protocol RunningPageViewModelOutputs {
    //	var isDraggingSubject: CurrentValueSubject<Bool, Never> { get }
    var buttonScaleRawSubject: CurrentValueSubject<Double, Never> { get }
    var buttonScaleSubject: AnyPublisher<Double, Never> { get }
    var buttonScaleSubject2: AnyPublisher<Double, Never> { get }
    var runningTimeSubject: AnyPublisher<String, Never> { get }
    var issueScaleValueSignal: PassthroughSubject<Void, Never> { get }
}

class RunningPageViewModel: RunningPageViewModelInputs, RunningPageViewModelOutputs {
    var buttonScaleSubject2: AnyPublisher<Double, Never> {
        issueScaleValueSignal.zip(buttonScaleRawSubject).map { $1 }.eraseToAnyPublisher()
    }

    var issueScaleValueSignal = PassthroughSubject<Void, Never>()

    func didScrollScreen() {
//        buttonScaleRawSubject.value = buttonScaleRawSubject.value
        issueScaleValueSignal.send()
    }

    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double) {
        let value = (contentOffset + screenWidth * Double(currentPageIdx - 2))
        buttonScaleRawSubject.send(value / screenWidth)
    }

    func currentPageDidChange(idx: Int) {
        currentPageIdx = idx
    }

    var currentPageIdx = 1

    private let runningDataProvider: RunningDataServiceable

    var buttonScaleRawSubject = CurrentValueSubject<Double, Never>(0)
    var buttonScaleSubject: AnyPublisher<Double, Never> {
        buttonScaleRawSubject.map { min(1, abs($0)) }.eraseToAnyPublisher()
    }

    var runningTimeSubject: AnyPublisher<String, Never> {
        runningDataProvider.runningTime
            .combineLatest(buttonScaleRawSubject)
            .receive(on: RunLoop.main)
            .map { runningTime, buttonScale in
                var text = runningTime.formattedString
                if buttonScale > 0 {
                    text = "<- " + text
                } else {
                    text += "-> "
                }
                return text
            }.eraseToAnyPublisher()
    }

    init(runningDataProvider: RunningDataServiceable) {
        self.runningDataProvider = runningDataProvider
    }

    func scrollViewDidEndDragging() {}

    func scrollViewWillBeginDragging() {}

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension RunningPageViewModel: RunningPageViewModelTypes {
    var inputs: RunningPageViewModelInputs { self }
    var outputs: RunningPageViewModelOutputs { self }
}
