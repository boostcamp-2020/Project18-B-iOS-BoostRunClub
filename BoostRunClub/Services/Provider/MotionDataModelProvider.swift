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

protocol MotionDataModelProvidable {
    func start()
    func stop()
    var motionType: CurrentValueSubject<MotionType, Never> { get }
}

final class MotionDataModelProvider: MotionDataModelProvidable {
    private let motion = CMMotionManager()
    private var timer: Timer? = Timer()
    private var isActive = false

    private let model: BRCActivityClassifierA? = {
        let configuration = MLModelConfiguration()
        return try? BRCActivityClassifierA(configuration: configuration)
    }()

    private let myModel: MyActivityClassifier? = {
        let configuration = MLModelConfiguration()
        return try? MyActivityClassifier(configuration: configuration)
    }()

    private let activityModel: ActivityClassifier? = {
        let configuration = MLModelConfiguration()
        return try? ActivityClassifier(configuration: configuration)
    }()

    private var attitudeArray = [CMAttitude]()
    private var gravityArray = [CMAcceleration]()
    private var accelerometerArray = [CMAcceleration]()
    private var rotationArray = [CMRotationRate]()
    private var array = [Double](repeating: 0, count: 400)

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
                                  self.attitudeArray.append(data.attitude)
                                  self.gravityArray.append(data.gravity)
                                  self.accelerometerArray.append(data.userAcceleration)
                                  self.rotationArray.append(data.rotationRate)

                                  if self.gravityArray.count >= 112 {
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

        let input = BRCActivityClassifierAInput(
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

        // swiftlint:disable:next line_length
//        let input = MyActivityClassifierInput(attitude_pitch: attiP, attitude_roll: attiR, attitude_yaw: attiY, gravity_x: gravX, gravity_y: gravY, gravity_z: gravZ, rotationRate_x: rotX, rotationRate_y: rotY, rotationRate_z: rotZ, userAcceleration_x: accX, userAcceleration_y: accY, userAcceleration_z: accZ, stateIn: stateIn)

        // swiftlint:disable:next line_length
//        let input = ActivityClassifierInput(attitude_pitch: attiP, attitude_roll: attiR, attitude_yaw: attiY, gravity_x: gravX, gravity_y: gravY, gravity_z: gravZ, rotationRate_x: rotX, rotationRate_y: rotY, rotationRate_z: rotZ, userAcceleration_x: accX, userAcceleration_y: accY, userAcceleration_z: accZ, stateIn: stateIn)
        guard let result = try? model?.prediction(input: input) else { return "" }
//        guard let result = try? myModel?.prediction(input: input) else { return "" }
//        guard let result = try? activityModel?.prediction(input: input) else { return "" }

        let runProb = result.labelProbability["jogging"] ?? 0
        let standingProb = result.labelProbability["standing"] ?? 0
        let walkingProb = result.labelProbability["walking"] ?? 0
//        print("[CORE MOTION] \(String(format: "run: %.2f", runProb * 100)) \(String(format: "walking: %.2f", walkingProb * 100)) \(String(format: "stand: %.2f", standingProb * 100))")
        return standingProb > 60 ? "standing" : "walking"
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
