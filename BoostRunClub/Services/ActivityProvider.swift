//
//  ActivityProvider.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import CoreData
import Foundation

protocol ActivityWritable {
    func addActivity(activity: Activity)
    func editActivity(activity: Activity)
}

protocol ActivityReadable {
    func fetchActivities() -> [Activity]
}

protocol ActivityManageable {
    var reader: ActivityReadable { get }
    var writer: ActivityWritable { get }
}

class ActivityProvider: ActivityWritable, ActivityReadable {
    let coreDataService: CoreDataServiceable

    init(coreDataService: CoreDataServiceable) {
        self.coreDataService = coreDataService
    }

    func addActivity(activity: Activity) {
        let zActivity = ZActivity(context: coreDataService.context)
        zActivity.avgPace = Int32(activity.avgPace)
        zActivity.distance = activity.distance
        zActivity.uuid = activity.uuid
        zActivity.thumbnail = activity.thumbnail
        zActivity.createdAt = activity.createdAt
        zActivity.duration = activity.duration
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
