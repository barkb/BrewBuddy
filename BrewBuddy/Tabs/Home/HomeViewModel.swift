//
//  HomeViewModel.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 6/10/21.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let playlistsController: NSFetchedResultsController<Playlist>
        private let beersController: NSFetchedResultsController<Beer>

        @Published var playlists = [Playlist]()
        @Published var beers = [Beer]()
        @Published var selectedBeer: Beer?

        var dataController: DataController

        var topRated: ArraySlice<Beer> {
            beers.prefix(3)
        }

        var moreToExplore: ArraySlice<Beer> {
            beers.dropFirst(3)
        }

        init(dataController: DataController) {
            self.dataController = dataController

            // construct a fetch request to show all open playlists
            let playlistRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
            playlistRequest.predicate = NSPredicate(format: "isActive = true")
            playlistRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Playlist.title, ascending: true)]
            playlistsController = NSFetchedResultsController(
                fetchRequest: playlistRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // construct a fetch request to show the 10 highest rated, favorited beers from open playlists
            let beerRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
            let favoritedPredicate = NSPredicate(format: "favorited = true")
            let ratingPredicate = NSPredicate(format: "rating = 5")
            let activePredicate = NSPredicate(format: "playlist.isActive = true")
            let compoundPredicate = NSCompoundPredicate(
                type: .and,
                subpredicates: [
                    activePredicate, favoritedPredicate, ratingPredicate
                ]
            )
            beerRequest.predicate = compoundPredicate
            beerRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Beer.rating, ascending: false)
            ]
            beerRequest.fetchLimit = 10

            beersController = NSFetchedResultsController(
                fetchRequest: beerRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            playlistsController.delegate = self
            beersController.delegate = self

            do {
                try playlistsController.performFetch()
                try beersController.performFetch()
                playlists = playlistsController.fetchedObjects ?? []
                beers = beersController.fetchedObjects ?? []
            } catch {
                debugPrint("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newBeers = controller.fetchedObjects as? [Beer] {
                beers = newBeers
            } else if let newPlaylists = controller.fetchedObjects as? [Playlist] {
                playlists = newPlaylists
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
        
        func selectBeer(with identifier: String) {
            selectedBeer = dataController.beer(with: identifier)
        }
    }
}
