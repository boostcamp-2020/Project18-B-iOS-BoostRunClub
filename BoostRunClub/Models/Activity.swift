//
//  Activity.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import Foundation

struct Activity {
    var avgPace: Int
    var distance: Double
    var duration: Double
    var thumbnail: Data?
    var createdAt: Date?
    var uuid: UUID?
}

extension Activity {
    init(zActivity: ZActivity) {
        self.init(avgPace: Int(zActivity.avgPace),
                  distance: zActivity.distance,
                  duration: zActivity.duration,
                  thumbnail: zActivity.thumbnail,
                  createdAt: zActivity.createdAt,
                  uuid: zActivity.uuid)
    }
}

// public class Activity: NSObject, NSSecureCoding {
//    enum CodingKeys {
//        static let distance = "distance"
//        static let avgPace = "avgPace"
//        static let createdAt = "createdAt"
//        static let duration = "duration"
//        static let thumbnail = "thumbnail"
//        static let uuid = "uuid"
//    }
//
//    var distance: Double = 0
//    var avgPace: Int = 0
//    var duration: Double = 0
//    var thumbnail: Data?
//    var createdAt = Date()
//    var uuid = UUID()
//
//    public static var supportsSecureCoding: Bool = true
//
//    public func encode(with coder: NSCoder) {
//        coder.encode(distance, forKey: CodingKeys.distance)
//        coder.encode(avgPace, forKey: CodingKeys.avgPace)
//        coder.encode(duration, forKey: CodingKeys.duration)
//        coder.encode(thumbnail, forKey: CodingKeys.thumbnail)
//        coder.encode(createdAt, forKey: CodingKeys.createdAt)
//        coder.encode(uuid, forKey: CodingKeys.uuid)
//    }
//
//    public required init?(coder: NSCoder) {
//        guard let createdAt = coder.decodeObject(forKey: CodingKeys.createdAt) as? NSDate,
//              let uuid = coder.decodeObject(forKey: CodingKeys.uuid) as? UUID
//        else { return nil }
//
//        distance = coder.decodeDouble(forKey: CodingKeys.distance)
//        avgPace = coder.decodeInteger(forKey: CodingKeys.avgPace)
//        duration = coder.decodeDouble(forKey: CodingKeys.duration)
//        thumbnail = coder.decodeObject(forKey: CodingKeys.thumbnail) as? Data
//        self.createdAt = createdAt as Date
//        self.uuid = uuid
//    }
//
//    override init() {}
// }

// class ActivityAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
//    override static var allowedTopLevelClasses: [AnyClass] {
//        [Activity.self]
//    }
//
//    static func register() {
//        let className = String(describing: ActivityAttributeTransformer.self)
//        // the key to the ValueTransformer
//        let name = NSValueTransformerName(className)
//        // the value to the ValueTransformer
//        let transformer = ActivityAttributeTransformer()
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
// }
