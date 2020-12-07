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

protocol SplitsViewModelOutputs {}

class SplitsViewModel: SplitsViewModelInputs, SplitsViewModelOutputs {
    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension SplitsViewModel: SplitsViewModelTypes {
    var inputs: SplitsViewModelInputs { self }
    var outputs: SplitsViewModelOutputs { self }
}
