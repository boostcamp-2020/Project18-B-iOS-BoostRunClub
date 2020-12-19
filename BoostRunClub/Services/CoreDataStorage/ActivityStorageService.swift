//
//  ActivityStorageService.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import Combine
import CoreData
import Foundation

protocol ActivityWritable {
    func addActivity(activity: Activity, activityDetail: ActivityDetail)
    func editActivity(activity: Activity)
}

protocol ActivityReadable {
    var activityChangeSignal: PassthroughSubject<Void, Never> { get }

    func fetchActivities() -> [Activity]
    func fetchActivityDetail(activityId: UUID) -> ActivityDetail?
}

protocol ActivityStorageServiceable {
    var reader: ActivityReadable { get }
    var writer: ActivityWritable { get }
}

class ActivityStorageService: ActivityWritable, ActivityReadable {
    let coreDataService: CoreDataServiceable

    init(coreDataService: CoreDataServiceable) {
        self.coreDataService = coreDataService
    }

    func addActivity(activity: Activity, activityDetail: ActivityDetail) {
        ZActivity(context: coreDataService.context, activity: activity)
        ZActivityDetail(context: coreDataService.context, activityDetail: activityDetail)

        do {
            try coreDataService.context.save()
            activityChangeSignal.send()
        } catch {
            print(error.localizedDescription)
        }
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

    func fetchActivityDetail(activityId: UUID) -> ActivityDetail? {
        let request: NSFetchRequest<ZActivityDetail> = ZActivityDetail.fetchRequest(activityId: activityId)
        do {
            let result = try coreDataService.context.fetch(request)
            return result.compactMap { $0.activityDetail }.first
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    var activityChangeSignal = PassthroughSubject<Void, Never>()
}

extension ActivityStorageService: ActivityStorageServiceable {
    var reader: ActivityReadable { self }
    var writer: ActivityWritable { self }
}
