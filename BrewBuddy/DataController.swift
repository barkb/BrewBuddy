//
//  DataController.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
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
    //Creates sample profile and beer data so we can test and see UI without having to create by hand
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let profile = Profile(context: viewContext)
            profile.title = "Profile \(i)"
            profile.beers = []
            profile.creationDate = Date().addingTimeInterval(TimeInterval(Int.random(in: 1...10000)))
            profile.isActive = Bool.random()
            
            for j in 1...10 {
                let beer = Beer(context: viewContext)
                beer.name = "Beer \(j)"
                beer.creationDate = Date()
                beer.profile = profile
                beer.rating = Int16.random(in: 1...5)
                
            }
        }
        
        try viewContext.save()
    }
    //Save function for only saving data if there are changes, so we're not doing unnecessary work
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    //Delete for deleting specific objects (beer or profile) for testing
    func delete(_ object: NSManagedObject){
        container.viewContext.delete(object)
    }
    
    //Deletes all test data for easy cleanup so we get fresh sample data every time we run app
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Beer.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Profile.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
}
