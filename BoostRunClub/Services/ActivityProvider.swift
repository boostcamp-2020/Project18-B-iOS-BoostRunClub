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
        print("-------------------------------------------------")
        print("-------------------------------------------------")
        print("-------------------------------------------------")
        let zActivity = ZActivity(context: coreDataService.context)
        zActivity.activity = activity
        do {
            try coreDataService.context.save()
        } catch {
            print(error.localizedDescription)
        }
        print("-------------------------------------------------")
        print("-------------------------------------------------")
        print("-------------------------------------------------")
        print(fetchActivities())
    }

    func editActivity(activity _: Activity) {}

    func fetchActivities() -> [Activity] {
        let request = NSFetchRequest<ZActivity>(entityName: "ZActivity")

        do {
            let result = try coreDataService.context.fetch(request)
            return result.compactMap { $0.activity }
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
