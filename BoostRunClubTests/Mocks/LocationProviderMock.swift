//
//  MockLocationProvider.swift
//  BoostRunClubTests
//
//  Created by 김신우 on 2020/11/28.
//

import Combine
import CoreLocation
import Foundation

class LocationProviderMock: LocationProvidable {
    var locationSubject = PassthroughSubject<CLLocation, Never>()

    func send(_ location: CLLocation) {
        locationSubject.send(location)
    }
}
