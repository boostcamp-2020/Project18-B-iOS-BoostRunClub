//
//  RunningSplitCellViewModel.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/09.
//

import Combine
import Foundation

protocol CellViewModelTypeBase {}

protocol RunningSplitCellViewModelType: CellViewModelTypeBase {
    var kilometerSubject: CurrentValueSubject<String, Never> { get }
    var paceSubject: CurrentValueSubject<String, Never> { get }
    var changeSubject: CurrentValueSubject<ValueChange?, Never> { get }
}

class RunningSplitCellViewModel: RunningSplitCellViewModelType {
    var kilometerSubject = CurrentValueSubject<String, Never>("")
    var paceSubject = CurrentValueSubject<String, Never>("")
    var changeSubject = CurrentValueSubject<ValueChange?, Never>(nil)
}

struct ValueChange {
    enum Status {
        case incresed, equal, decreased
    }

    let status: Status
    let value: String
}
