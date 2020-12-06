//
//  ZActivity+Activity.swift
//  BoostRunClub
//
//  Created by 조기현 on 2020/12/06.
//

import CoreData
import Foundation

extension ZActivity {
    @discardableResult
    convenience init(context: NSManagedObjectContext, activity: Activity) {
        self.init(context: context)
        avgPace = Int32(activity.avgPace)
        distance = activity.distance
        uuid = activity.uuid
        thumbnail = activity.thumbnail
        createdAt = activity.createdAt
        duration = activity.duration
    }
}
