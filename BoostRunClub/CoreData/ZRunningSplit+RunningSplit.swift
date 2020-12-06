//
//  ZRunningSplit+RunningSplit.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import CoreData
import Foundation

@objc(ZRunningSplit)
public class ZRunningSplit: NSManagedObject {
    @NSManaged public var avgBPM: Int32
    @NSManaged public var avgPace: Int32
    @NSManaged public var elevation: Int32
    @NSManaged public var distance: Double
    @NSManaged public var activityUUID: UUID?
    @NSManaged public var runningSlices: Data?
}

extension ZRunningSplit {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZRunningSplit> {
        return NSFetchRequest<ZRunningSplit>(entityName: "ZRunningSplit")
    }

    public class func fetchRequest(activityId: UUID) -> NSFetchRequest<ZRunningSplit> {
        let fetchRequest: NSFetchRequest<ZRunningSplit> = NSFetchRequest(entityName: "ZRunningSplit")
        fetchRequest.predicate = NSPredicate(format: "activityUUID == %@", activityId as CVarArg)
        return fetchRequest
    }

    @discardableResult
    convenience init(context: NSManagedObjectContext, runningSplit: RunningSplit) {
        self.init(context: context)
        activityUUID = runningSplit.activityUUID
        avgBPM = Int32(runningSplit.avgBPM)
        avgPace = Int32(runningSplit.avgPace)
        distance = runningSplit.distance
        elevation = Int32(runningSplit.elevation)
        runningSlices = try? JSONEncoder().encode(runningSplit.runningSlices)
    }

    var runningSplit: RunningSplit {
        var slice: [RunningSlice] = []
        if
            let data = runningSlices,
            let slices = try? JSONDecoder().decode([RunningSlice].self, from: data)
        {
            slice.append(contentsOf: slices)
        }

        return RunningSplit(
            activityUUID: activityUUID,
            avgBPM: Int(avgBPM),
            avgPace: Int(avgPace),
            distance: distance,
            elevation: Int(elevation),
            runningSlices: slice
        )
    }
}
