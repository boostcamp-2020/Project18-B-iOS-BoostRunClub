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

final class MotionProvider {
    private let motion = CMMotionManager()
    private let pedometer = CMPedometer()
    private var isActive = false
    private var timer: Timer? = Timer()
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

    var currentMotionType = CurrentValueSubject<MotionType, Never>(.standing)
    var cadence = CurrentValueSubject<Int, Never>(0)

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
                                          self.currentMotionType.send(.running)
                                      case "standing":
                                          self.currentMotionType.send(.standing)
                                      default:
                                          self.currentMotionType.send(.standing)
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

    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }

    func stopActivityUpdates() {
        timer?.invalidate()
        isActive = false
    }

    func startCountingSteps() {
        pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in

            guard
                let self = self,
                let cadence = pedometerData?.currentCadence,
                error == nil
            else { return }

            self.cadence.value = Int(truncating: cadence) * 60
        }
    }
}
