//
//  CoreDataService.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/06.
//

import CoreData
import Foundation

protocol CoreDataServiceable {
    var context: NSManagedObjectContext { get }
}

class CoreDataService: CoreDataServiceable {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BRCModel")
        container.loadPersistentStores { description, error in
            print(description)
            guard let error = error as NSError? else { return }
            fatalError("persistent store error: \(error)")
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
