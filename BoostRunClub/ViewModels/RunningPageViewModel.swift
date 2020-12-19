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
    // Data For Configure
    var runningTimeSubject: AnyPublisher<String, Never> { get }

    // Signal For View Action
    var speechSignal: PassthroughSubject<String, Never> { get }
    var scaleOnDraggingSubject: PassthroughSubject<Double, Never> { get }
    var scaleOnSlidingSubject: AnyPublisher<Double, Never> { get }
    var setPageSignal: PassthroughSubject<Int, Never> { get }

    // Signal For Coordinate
    var backToPageMainSignal: PassthroughSubject<Int, Never> { get }
}

class RunningPageViewModel: RunningPageViewModelInputs, RunningPageViewModelOutputs {
    private let runningService: RunningServiceType
    private var isDragging: Bool = false
    private var currentPageIdx = 1
    private var cancellables = Set<AnyCancellable>()
    private var readyToChagePageIdx = false

    @Published private var scale: Double = 0.0

    init(runningService: RunningServiceType) {
        self.runningService = runningService

        runningService.runningEventSubject
            .sink { [weak self] event in
                print("[SPEAK!]!!!!!!!!!!!!!!!!!!!!\(event.text)")
                self?.speechSignal.send(event.text)
            }.store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // Inputs

    func buttonScaleShouldUpdate(contentOffset: Double, screenWidth: Double) {
        readyToChagePageIdx = contentOffset == 0 || contentOffset == screenWidth * 2
        let value = (contentOffset + screenWidth * Double(currentPageIdx - 2))
        let result = value / screenWidth

        if abs(result) > 1 { return }
        scale = result
    }

    func didTapGoBackButton() {
        backToPageMainSignal.send(currentPageIdx)
    }

    func dragging() {
        scaleOnDraggingSubject.send(scale)
    }

    func didChangeCurrentPage(idx: Int) {
        if readyToChagePageIdx {
            currentPageIdx = idx
        } else {
            setPageSignal.send(currentPageIdx)
        }
    }

    func didEndDragging() {
        isDragging = false
    }

    func willBeginDragging() {
        isDragging = true
    }

    // Outputs

    var speechSignal = PassthroughSubject<String, Never>()
    var scaleOnDraggingSubject = PassthroughSubject<Double, Never>()
    var backToPageMainSignal = PassthroughSubject<Int, Never>()
    var setPageSignal = PassthroughSubject<Int, Never>()
    var scaleOnSlidingSubject: AnyPublisher<Double, Never> {
        $scale
            .filter { _ in !self.isDragging }
            .map { abs($0) }
            .eraseToAnyPublisher()
    }

    var runningTimeSubject: AnyPublisher<String, Never> {
        runningService.dashBoardService.runningTime
            .map { $0.fullFormattedString }
            .eraseToAnyPublisher()
    }
}

extension RunningPageViewModel: RunningPageViewModelTypes {
    var inputs: RunningPageViewModelInputs { self }
    var outputs: RunningPageViewModelOutputs { self }
}
