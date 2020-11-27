//
//  RunningMapViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/27.
//

import Combine
import Foundation

protocol RunningMapViewModelTypes {
    var inputs: RunningMapViewModelInputs { get }
    var outputs: RunningMapViewModelOutputs { get }
}

protocol RunningMapViewModelInputs {}

protocol RunningMapViewModelOutputs {}

class RunningMapViewModel: RunningMapViewModelInputs, RunningMapViewModelOutputs {}

extension RunningMapViewModel: RunningMapViewModelTypes {
    var inputs: RunningMapViewModelInputs { self }
    var outputs: RunningMapViewModelOutputs { self }
}
