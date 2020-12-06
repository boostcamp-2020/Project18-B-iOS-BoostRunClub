//
//  ActivityProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import CoreData
import Foundation

protocol ActivityWritable {
    func addActivity(activity: Activity, activityDetail: ActivityDetail)
    func editActivity(activity: Activity)
}

protocol ActivityReadable {
    func fetchActivities() -> [Activity]
    func fetchActivityDetail(activityId: UUID) -> ActivityDetail?
}

protocol ActivityManageable {
    var reader: ActivityReadable { get }
    var writer: ActivityWritable { get }
}

class ActivityProvider: ActivityWritable, ActivityReadable {
    func fetchActivityDetail(activityId _: UUID) -> ActivityDetail? {
        nil
    }

    let coreDataService: CoreDataServiceable

    init(coreDataService: CoreDataServiceable) {
        self.coreDataService = coreDataService
    }

    func addActivity(activity: Activity, activityDetail: ActivityDetail) {
        ZActivity(context: coreDataService.context, activity: activity)
        ZActivityDetail(context: coreDataService.context, activityDetail: activityDetail)
        do {
            try coreDataService.context.save()
        } catch {
            print(error.localizedDescription)
        }
        fetchActivities().forEach {
            print($0.distance)
        }
    }

    func editActivity(activity _: Activity) {}

    func fetchActivities() -> [Activity] {
        let request = NSFetchRequest<ZActivity>(entityName: "ZActivity")

        do {
            let result = try coreDataService.context.fetch(request)
            return result.map { Activity(zActivity: $0) }
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
}

extension ActivityProvider: ActivityManageable {
    var reader: ActivityReadable { self }
    var writer: ActivityWritable { self }
}
