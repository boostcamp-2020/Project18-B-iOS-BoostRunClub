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
    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double)
    func didChangeCurrentPage(idx: Int)
    func didTapGoBackButton()
    func dragging()
    func didEndDragging()
    func willBeginDragging()
}

protocol RunningPageViewModelOutputs {
    var scaleSubject: PassthroughSubject<Double, Never> { get }
    var scaleSubjectNotDragging: AnyPublisher<Double, Never> { get }
    var goBackToMainPageSignal: PassthroughSubject<Int, Never> { get }
    var runningTimeSubject: AnyPublisher<String, Never> { get }
}

class RunningPageViewModel: RunningPageViewModelInputs, RunningPageViewModelOutputs {
    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double) {
        let value = (contentOffset + screenWidth * Double(currentPageIdx - 2))
        let result = value / screenWidth
        if result >= 1 { return }
        scale = result
        print(scale)
    }

    func didTapGoBackButton() {
        goBackToMainPageSignal.send(currentPageIdx)
    }

    var scaleSubjectNotDragging: AnyPublisher<Double, Never> {
        $scale
            .filter { _ in !self.isDragging }
            .map { abs($0) }
            .eraseToAnyPublisher()
    }

    func dragging() {
        if isDragging {
            scaleSubject.send(abs(scale))
        }
    }

    func didChangeCurrentPage(idx: Int) {
        currentPageIdx = idx
    }

    func didEndDragging() {
        isDragging = false
    }

    func willBeginDragging() {
        isDragging = true
    }

    var goBackToMainPageSignal = PassthroughSubject<Int, Never>()

    var isDragging: Bool = false
    var scaleSubject = PassthroughSubject<Double, Never>()
    @Published var scale: Double = 0.0

    var currentPageIdx = 1

    private let runningDataProvider: RunningDataServiceable

    var runningTimeSubject: AnyPublisher<String, Never> {
        runningDataProvider.runningTime
            .combineLatest($scale)
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

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension RunningPageViewModel: RunningPageViewModelTypes {
    var inputs: RunningPageViewModelInputs { self }
    var outputs: RunningPageViewModelOutputs { self }
}
