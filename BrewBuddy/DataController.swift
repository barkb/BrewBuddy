//
//  DataController.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including
/// handling saving, counting fetch requests, tracking awards, and dealing with sample
/// data.
class DataController: ObservableObject {

    /// The lone CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer


    /// Creates a data controller instance with a container either in-memory (for testing
    /// purposes) or on permanent storage (for normal app use). Defaults to permanent
    /// storage.
    /// - Parameter inMemory: Boolean specifying whether data store should be created in
    /// temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        // For testing and previewing data is written to in-memory database
        // by writing to /dev/null so data is destroyed when app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static var preview: DataController = {
       let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        return dataController
    }()


    /// Creates example profiles and beers to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for profileCounter in 1...5 {
            let profile = Profile(context: viewContext)
            profile.title = "Profile \(profileCounter)"
            profile.beers = []
            profile.creationDate = Date().addingTimeInterval(TimeInterval(Int.random(in: 1...10000)))
            profile.isActive = Bool.random()

            for beerCounter in 1...10 {
                let beer = Beer(context: viewContext)
                beer.name = "Beer \(beerCounter)"
                beer.creationDate = Date()
                beer.profile = profile
                beer.rating = Int16.random(in: 1...5)
                beer.favorited = Bool.random()
            }
        }

        try viewContext.save()
    }

    /// Saves data if there are changes, ignores any errors caused by saving, but
    /// shouldn't cause any problems because attributes are optionaln 
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    // Delete for deleting specific objects (beer or profile) for testing
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    // Deletes all test data for easy cleanup so we get fresh sample data every time we run app
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Beer.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Profile.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "beers":
            // returns true if user added a certain number of beers
            let fetchRequest: NSFetchRequest<Beer> = NSFetchRequest(entityName: "Beer")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "favorite":
            // returns true if user favorited a certain number of beers.
            let fetchRequest: NSFetchRequest<Beer> = NSFetchRequest(entityName: "Beer")
            fetchRequest.predicate = NSPredicate(format: "favorited = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
