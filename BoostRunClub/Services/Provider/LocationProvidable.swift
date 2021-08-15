//
//  LocationProvidable.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/20.
//

import Combine
import CoreLocation
import Foundation

protocol LocationProvidable {
    var locationSubject: PassthroughSubject<CLLocation, Never> { get }
    func startBackgroundTask()
    func stopBackgroundTask()
}
