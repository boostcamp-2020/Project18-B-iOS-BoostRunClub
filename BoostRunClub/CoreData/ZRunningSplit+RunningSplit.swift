//
//  ZRunningSplit+RunningSplit.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import CoreData
import Foundation

extension ZRunningSplit {
    public class func fetchRequest(activityId: UUID) -> NSFetchRequest<ZRunningSplit> {
        var fetchRequest: NSFetchRequest<ZRunningSplit> = NSFetchRequest(entityName: "ZRunningSplit")
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
}
