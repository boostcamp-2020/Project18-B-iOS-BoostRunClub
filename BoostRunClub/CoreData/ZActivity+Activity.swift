//
//  ZActivity+Activity.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import CoreData
import Foundation

@objc(ZActivity)
public class ZActivity: NSManagedObject {
    @NSManaged public var avgPace: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var finishedAt: Date?
    @NSManaged public var distance: Double
    @NSManaged public var duration: Double
    @NSManaged public var thumbnail: Data?
    @NSManaged public var uuid: UUID?
    @NSManaged public var elevation: Double
}

extension ZActivity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZActivity> {
        return NSFetchRequest<ZActivity>(entityName: "ZActivity")
    }

    @discardableResult
    convenience init(context: NSManagedObjectContext, activity: Activity) {
        self.init(context: context)
        avgPace = Int32(activity.avgPace)
        distance = activity.distance
        uuid = activity.uuid
        thumbnail = activity.thumbnail
        createdAt = activity.createdAt
        finishedAt = activity.finishedAt
        duration = activity.duration
    }

    var activity: Activity? {
        Activity(
            avgPace: Int(avgPace),
            distance: distance,
            duration: duration,
            elevation: elevation,
            thumbnail: thumbnail,
            createdAt: createdAt,
            finishedAt: finishedAt,
            uuid: uuid
        )
    }
}
