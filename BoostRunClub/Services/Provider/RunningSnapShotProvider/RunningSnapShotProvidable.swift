//
//  RunningSnapShotProvidable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation.CLLocation
import Foundation

protocol RunningSnapShotProvidable {
    func takeSnapShot(from locations: [CLLocation], dimension: Double) -> AnyPublisher<Data?, Error>
}
