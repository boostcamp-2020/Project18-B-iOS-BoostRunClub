//
//  MotionProvider.swift
//  BoostRunClub
//
//  Created by Imho Jang on 2020/12/03.
//

import Combine
import CoreML
import CoreMotion
import Foundation

protocol MotionProvidable {
    func start()
    func stop()
    var motionType: CurrentValueSubject<MotionType, Never> { get }
}

final class MotionProvider: MotionProvidable {
    private let motion = CMMotionManager()
    private var timer: Timer? = Timer()
    private var isActive = false
    private let model: BRCActivityClassifierA? = {
        let configuration = MLModelConfiguration()
        return try? BRCActivityClassifierA(configuration: configuration)
    }()

    var gravityArray = [CMAcceleration]()
    var accelerometerArray = [CMAcceleration]()
    var rotationArray = [CMRotationRate]()
    var attitudeArray = [CMAttitude]()
    var array: [Double] {
        return Array<Double>.init(repeating: 0, count: 400)
    }

    var motionType = CurrentValueSubject<MotionType, Never>(.standing)

    func startTrackingActivityType() {
        if isActive { return }

        isActive = true

        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 50.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)

            timer = Timer(fire: Date(), interval: 1.0 / 50.0, repeats: true,
                          block: { _ in
                              if let data = self.motion.deviceMotion {
                                  self.gravityArray.append(data.gravity)
                                  self.accelerometerArray.append(data.userAcceleration)
                                  self.rotationArray.append(data.rotationRate)

                                  if self.gravityArray.count >= 100 {
                                      let result = self.getActivity(
                                          gravity: self.gravityArray,
                                          accelometer: self.accelerometerArray,
                                          rotation: self.rotationArray,
                                          attitude: self.attitudeArray
                                      )

                                      self.gravityArray = []
                                      self.accelerometerArray = []
                                      self.rotationArray = []

                                      switch result {
                                      case "walking":
                                          self.motionType.send(.running)
                                      case "standing":
                                          self.motionType.send(.standing)
                                      default:
                                          self.motionType.send(.standing)
                                      }
                                  }
                              }
                          })

            RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        }
    }

    func getActivity(
        gravity: [CMAcceleration],
        accelometer: [CMAcceleration],
        rotation: [CMRotationRate],
        attitude _: [CMAttitude]
    )
        -> String
    {
        guard let gravX = try? MLMultiArray(gravity.map { $0.x }),
              let gravY = try? MLMultiArray(gravity.map { $0.y }),
              let gravZ = try? MLMultiArray(gravity.map { $0.z }),
              let rotationRateX = try? MLMultiArray(rotation.map { $0.x }),
              let rotationRateY = try? MLMultiArray(rotation.map { $0.y }),
              let rotationRateZ = try? MLMultiArray(rotation.map { $0.z }),
              let userAccelerationX = try? MLMultiArray(accelometer.map { $0.x }),
              let userAccelerationY = try? MLMultiArray(accelometer.map { $0.y }),
              let userAccelerationZ = try? MLMultiArray(accelometer.map { $0.z }),
              let stateIn = try? MLMultiArray(array)
        else { return "" }

        let input = BRCActivityClassifierAInput(
            gravity_x: gravX,
            gravity_y: gravY,
            gravity_z: gravZ,
            rotationRate_x: rotationRateX,
            rotationRate_y: rotationRateY,
            rotationRate_z: rotationRateZ,
            userAcceleration_x: userAccelerationX,
            userAcceleration_y: userAccelerationY,
            userAcceleration_z: userAccelerationZ,
            stateIn: stateIn
        )
        guard let result = try? model?.prediction(input: input) else { return "" }
        return result.label
    }

    func start() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
    }

    func stop() {
        timer?.invalidate()
        isActive = false
    }
}
