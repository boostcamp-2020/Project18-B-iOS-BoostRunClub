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

final class MotionDataModelProvider: MotionDataModelProvidable {
    private let motion = CMMotionManager()
    private var timer: Timer? = Timer()
    private var isActive = false

    private let runningModel: RunningMotionClassifier? = {
        let configuration = MLModelConfiguration()
        return try? RunningMotionClassifier(configuration: configuration)
    }()

    private var attitudeArray = [CMAttitude]()
    private var gravityArray = [CMAcceleration]()
    private var accelerometerArray = [CMAcceleration]()
    private var rotationArray = [CMRotationRate]()
    private var array = [Double](repeating: 0, count: 400)

    var motionTypeSubject = PassthroughSubject<MotionType, Never>()

    func startTrackingActivityType() {
        if isActive { return }
        isActive = true

        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 100.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)

            timer = Timer(fire: Date(), interval: 1.0 / 100.0, repeats: true,
                          block: { _ in
                              if let data = self.motion.deviceMotion {
                                  self.attitudeArray.append(data.attitude)
                                  self.gravityArray.append(data.gravity)
                                  self.accelerometerArray.append(data.userAcceleration)
                                  self.rotationArray.append(data.rotationRate)

                                  if self.gravityArray.count >= 100 {
                                      let result = self.getActivity(
                                          attitude: self.attitudeArray,
                                          gravity: self.gravityArray,
                                          accelometer: self.accelerometerArray,
                                          rotation: self.rotationArray
                                      )

                                      self.attitudeArray.removeAll()
                                      self.gravityArray.removeAll()
                                      self.accelerometerArray.removeAll()
                                      self.rotationArray.removeAll()

                                      switch result {
                                      case "walking":
                                          self.motionTypeSubject.send(.running)
                                      case "standing":
                                          self.motionTypeSubject.send(.standing)
                                      default:
                                          self.motionTypeSubject.send(.standing)
                                      }
                                  }
                              }
                          })

            RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        }
    }

    func getActivity(
        attitude: [CMAttitude],
        gravity: [CMAcceleration],
        accelometer: [CMAcceleration],
        rotation: [CMRotationRate]
    )
        -> String
    {
        guard
            let attiP = try? MLMultiArray(attitude.map { $0.pitch }),
            let attiR = try? MLMultiArray(attitude.map { $0.roll }),
            let attiY = try? MLMultiArray(attitude.map { $0.yaw }),
            let gravX = try? MLMultiArray(gravity.map { $0.x }),
            let gravY = try? MLMultiArray(gravity.map { $0.y }),
            let gravZ = try? MLMultiArray(gravity.map { $0.z }),
            let rotX = try? MLMultiArray(rotation.map { $0.x }),
            let rotY = try? MLMultiArray(rotation.map { $0.y }),
            let rotZ = try? MLMultiArray(rotation.map { $0.z }),
            let accX = try? MLMultiArray(accelometer.map { $0.x }),
            let accY = try? MLMultiArray(accelometer.map { $0.y }),
            let accZ = try? MLMultiArray(accelometer.map { $0.z }),
            let stateIn = try? MLMultiArray(array)
        else { return "" }

        let input = RunningMotionClassifierInput(
            attitude_pitch: attiP,
            attitude_roll: attiR,
            attitude_yaw: attiY,
            gravity_x: gravX,
            gravity_y: gravY,
            gravity_z: gravZ,
            rotationRate_x: rotX,
            rotationRate_y: rotY,
            rotationRate_z: rotZ,
            userAcceleration_x: accX,
            userAcceleration_y: accY,
            userAcceleration_z: accZ,
            stateIn: stateIn
        )

        guard let result = try? runningModel?.prediction(input: input) else { return "" }
        let standingProb = result.labelProbability["standing"] ?? 0
        let walkingProb = result.labelProbability["running"] ?? 0
        print("[CORE MOTION] \(String(format: "walking: %.2f", walkingProb * 100)) \(String(format: "stand: %.2f", standingProb * 100))")
        return standingProb > 0.55 ? "standing" : "walking"
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
