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
    var speechSignal: PassthroughSubject<String, Never> { get }
    var scaleSubject: PassthroughSubject<Double, Never> { get }
    var scaleSubjectNotDragging: AnyPublisher<Double, Never> { get }
    var goBackToMainPageSignal: PassthroughSubject<Int, Never> { get }
    var runningTimeSubject: AnyPublisher<String, Never> { get }
}

class RunningPageViewModel: RunningPageViewModelInputs, RunningPageViewModelOutputs {
    private let runningDataProvider: RunningDataServiceable
    private var isDragging: Bool = false
    private var currentPageIdx = 1
    private var cancellables = Set<AnyCancellable>()

    @Published private var scale: Double = 0.0

    init(runningDataProvider: RunningDataServiceable) {
        self.runningDataProvider = runningDataProvider

        runningDataProvider.runningEvent
            .sink { [weak self] event in
                self?.speechSignal.send(event.text)
            }.store(in: &cancellables)
    }

    // Inputs

    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double) {
        let value = (contentOffset + screenWidth * Double(currentPageIdx - 2))
        let result = value / screenWidth
        if result >= 1 { return }
        scale = result
    }

    func didTapGoBackButton() {
        goBackToMainPageSignal.send(currentPageIdx)
    }

    func dragging() {
        scaleSubject.send(abs(scale))
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

    // Outputs

    var speechSignal = PassthroughSubject<String, Never>()
    var scaleSubject = PassthroughSubject<Double, Never>()
    var goBackToMainPageSignal = PassthroughSubject<Int, Never>()
    var scaleSubjectNotDragging: AnyPublisher<Double, Never> {
        $scale
            .filter { _ in !self.isDragging }
            .map { abs($0) }
            .eraseToAnyPublisher()
    }

    var runningTimeSubject: AnyPublisher<String, Never> {
        runningDataProvider.runningTime
            .map { $0.fullFormattedString }
            .eraseToAnyPublisher()
    }

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension RunningPageViewModel: RunningPageViewModelTypes {
    var inputs: RunningPageViewModelInputs { self }
    var outputs: RunningPageViewModelOutputs { self }
}
