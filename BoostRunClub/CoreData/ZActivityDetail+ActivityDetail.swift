//
//  ZActivityDetail+ActivityDetail.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import CoreData
import Foundation

extension ZActivityDetail {
    public class func fetchRequest(activityId: UUID) -> NSFetchRequest<ZActivityDetail> {
        var fetchRequest: NSFetchRequest<ZActivityDetail> = NSFetchRequest(entityName: "ZActivityDetail")
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
}
