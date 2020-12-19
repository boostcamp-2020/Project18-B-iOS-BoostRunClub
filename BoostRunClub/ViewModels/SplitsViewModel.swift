//
//  SplitsViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Combine
import Foundation

protocol SplitsViewModelTypes {
    var inputs: SplitsViewModelInputs { get }
    var outputs: SplitsViewModelOutputs { get }
}

protocol SplitsViewModelInputs {}

protocol SplitsViewModelOutputs {
    var rowViewModelSubject: CurrentValueSubject<[RunningSplitCellViewModelType], Never> { get }
}

class SplitsViewModel: SplitsViewModelInputs, SplitsViewModelOutputs {
    let runningService: RunningServiceType
    let factory: SplitSceneFactory
    var cancellables = Set<AnyCancellable>()
    var avgPaces = [Int]()

    init(runningService: RunningServiceType, factory: SplitSceneFactory = DependencyFactory.shared) {
        self.runningService = runningService
        self.factory = factory

        runningService.recordService.didAddSplitSignal
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.newSplitAction(split: $0) }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // outputs
    var rowViewModelSubject = CurrentValueSubject<[RunningSplitCellViewModelType], Never>([])
}

extension SplitsViewModel {
    func newSplitAction(split: RunningSplit) {
        let currRowVM = factory.makeRunningSplitCellVM()
        let kilometer = rowViewModelSubject.value.count + 1
        let currPace = split.avgPace
        let valueChange: ValueChange?
        if let prevPace = avgPaces.last {
            let status: ValueChange.Status = prevPace == currPace ? .equal : prevPace < currPace ? .incresed : .decreased
            valueChange = ValueChange(status: status,
                                      value: abs(currPace - prevPace).formattedString)
        } else {
            valueChange = nil
        }

        currRowVM.kilometerSubject.send("\(kilometer)")
        currRowVM.paceSubject.send(currPace.formattedString)
        currRowVM.changeSubject.send(valueChange)

        avgPaces.append(split.avgPace)
        rowViewModelSubject.value.append(currRowVM)
    }
}

extension SplitsViewModel: SplitsViewModelTypes {
    var inputs: SplitsViewModelInputs { self }
    var outputs: SplitsViewModelOutputs { self }
}

extension Int {
    var formattedString: String {
        String(format: "%d'%d\"", self / 60, self % 60)
    }
}
