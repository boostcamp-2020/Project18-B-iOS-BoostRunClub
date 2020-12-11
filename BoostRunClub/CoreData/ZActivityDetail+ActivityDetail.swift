//
//  ZActivityDetail+ActivityDetail.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import CoreData
import Foundation

@objc(ZActivityDetail)
public class ZActivityDetail: NSManagedObject {
    @NSManaged public var activityUUID: UUID?
    @NSManaged public var avgBPM: Int32
    @NSManaged public var cadence: Int32
    @NSManaged public var calorie: Int32
    @NSManaged public var elevation: Int32
    @NSManaged public var locations: Data?
}

extension ZActivityDetail {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZActivityDetail> {
        return NSFetchRequest<ZActivityDetail>(entityName: "ZActivityDetail")
    }

    public class func fetchRequest(activityId: UUID) -> NSFetchRequest<ZActivityDetail> {
        let fetchRequest: NSFetchRequest<ZActivityDetail> = NSFetchRequest(entityName: "ZActivityDetail")
        fetchRequest.predicate = NSPredicate(format: "activityUUID == %@", activityId as CVarArg)
        return fetchRequest
    }

    @discardableResult
    convenience init(context: NSManagedObjectContext, activityDetail: ActivityDetail) {
        self.init(context: context)
        activityUUID = activityDetail.activityUUID
        avgBPM = Int32(activityDetail.avgBPM)
        cadence = Int32(activityDetail.cadence)
        calorie = Int32(activityDetail.calorie)
        elevation = Int32(activityDetail.elevation)
        locations = try? JSONEncoder().encode(activityDetail.locations)
    }

    var activityDetail: ActivityDetail? {
        var location: [Location] = []
        if
            let data = locations,
            let locations = try? JSONDecoder().decode([Location].self, from: data)
        {
            location.append(contentsOf: locations)
        }

        return ActivityDetail(
            activityUUID: activityUUID,
            avgBPM: Int(avgBPM),
            cadence: Int(cadence),
            calorie: Int(calorie),
            elevation: Int(elevation),
            locations: location
        )
    }
}
