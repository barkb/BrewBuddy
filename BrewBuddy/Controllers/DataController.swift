//
//  DataController.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//

import CoreData
import CoreSpotlight
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
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        // For testing and previewing data is written to in-memory database
        // by writing to /dev/null so data is destroyed when app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
                UIView.setAnimationsEnabled(false)
            }
            #endif
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

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// Creates example playlists and beers to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for playlistCounter in 1...5 {
            let playlist = Playlist(context: viewContext)
            playlist.title = "Playlist \(playlistCounter)"
            playlist.beers = []
            playlist.creationDate = Date().addingTimeInterval(TimeInterval(Int.random(in: 1...10000)))
            playlist.isActive = Bool.random()

            for beerCounter in 1...10 {
                let beer = Beer(context: viewContext)
                beer.name = "Beer \(beerCounter)"
                beer.creationDate = Date()
                beer.playlist = playlist
                beer.rating = Int16.random(in: 1...5)
                beer.favorited = Bool.random()
            }
        }

        try viewContext.save()
    }

    /// Saves data if there are changes, ignores any errors caused by saving, but
    /// shouldn't cause any problems because attributes are optional
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    // Delete for deleting specific objects (beer or playlist) for testing
    func delete(_ object: NSManagedObject) {
        // swiftlint:disable:next identifier_name
        let id = object.objectID.uriRepresentation().absoluteString
        if object is Beer {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
        } else {
            CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
        }

        container.viewContext.delete(object)
    }

    // Deletes all test data for easy cleanup so we get fresh sample data every time we run app
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Beer.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Playlist.fetchRequest()
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

    func updateSpotlightAndSave(_ beer: Beer) {
        let beerID = beer.objectID.uriRepresentation().absoluteString
        let playlistID = beer.playlist?.objectID.uriRepresentation().absoluteString

        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = beer.beerName
        attributeSet.contentDescription =
            "\(beer.playlist?.playlistTitle ?? "") - \(beer.beerBrewery) - \(beer.beerType)\n\(beer.beerDetail)"

        let searchableBeer = CSSearchableItem(
            uniqueIdentifier: beerID,
            domainIdentifier: playlistID,
            attributeSet: attributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableBeer])

        save()
    }

    func beer(with uniqeIdentifier: String) -> Beer? {
        guard let url = URL(string: uniqeIdentifier) else {
            return nil
        }
        // swiftlint:disable:next identifier_name
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }

        return try? container.viewContext.existingObject(with: id) as? Beer
    }

    func addPlaylist() {
        let playlist = Playlist(context: container.viewContext)
        playlist.isActive = true
        playlist.creationDate = Date()
        save()
    }
}
