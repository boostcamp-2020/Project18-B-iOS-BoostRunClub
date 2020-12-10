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
}

protocol RunningPageViewModelOutputs {
    //	var isDraggingSubject: CurrentValueSubject<Bool, Never> { get }
    var buttonScaleSubject: CurrentValueSubject<Double, Never> { get }
    var runningTimeSubject: AnyPublisher<String, Never> { get }
}

class RunningPageViewModel: RunningPageViewModelInputs, RunningPageViewModelOutputs {
    private let runningDataProvider: RunningDataServiceable

    var buttonScaleSubject = CurrentValueSubject<Double, Never>(0)
    var runningTimeSubject: AnyPublisher<String, Never> {
        runningDataProvider.runningTime.map { $0.formattedString }.eraseToAnyPublisher()
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
