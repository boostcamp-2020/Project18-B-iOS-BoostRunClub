//
//  RouteDetailViewModel.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/13.
//

import Combine
import Foundation
import MapKit
import UIKit

protocol RouteDetailViewModelTypes: AnyObject {
    var inputs: RouteDetailViewModelInputs { get }
    var outputs: RouteDetailViewModelOutputs { get }
}

protocol RouteDetailViewModelInputs {
    func viewDidLoad()
    func didTapCloseButton()
}

protocol RouteDetailViewModelOutputs {
    var closeSignal: PassthroughSubject<Void, Never> { get }
    var regionSignal: PassthroughSubject<MKCoordinateRegion, Never> { get }
}

final class RouteDetailViewModel: RouteDetailViewModelInputs, RouteDetailViewModelOutputs {
    let activityDetailConfig: ActivityDetailConfig

    init(activityDetailConfig: ActivityDetailConfig) {
        self.activityDetailConfig = activityDetailConfig
    }

    // inputs
    func viewDidLoad() {
        let locationCoordinates: [CLLocationCoordinate2D] = activityDetailConfig
            .locations
            .map {
                (location: Location) in
                CLLocationCoordinate2D(latitude: location.latitude,
                                       longitude: location.longitude)
            }

        let region = MKCoordinateRegion.make(from: locationCoordinates)
        regionSignal.send(region)
    }

    func didTapCloseButton() {
        closeSignal.send()
    }

    // outputs
    var closeSignal = PassthroughSubject<Void, Never>()
    var regionSignal = PassthroughSubject<MKCoordinateRegion, Never>()

    deinit {
        print("[\(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }
}

extension RouteDetailViewModel: RouteDetailViewModelTypes {
    var inputs: RouteDetailViewModelInputs { self }
    var outputs: RouteDetailViewModelOutputs { self }
}
