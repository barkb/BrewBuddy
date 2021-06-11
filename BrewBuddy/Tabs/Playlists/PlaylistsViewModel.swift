//
//  PlaylistsViewModel.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 6/10/21.
//

import Foundation
import CoreData
import SwiftUI

extension PlaylistsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

        let dataController: DataController
        var sortOrder = Beer.SortOrder.optimized

        let showActivePlaylists: Bool
        private let playlistsController: NSFetchedResultsController<Playlist>
        @Published var playlists = [Playlist]()

        init(dataController: DataController, showActivePlaylists: Bool) {
            self.dataController = dataController
            self.showActivePlaylists = showActivePlaylists

            let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Playlist.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "isActive = %d", showActivePlaylists)

            playlistsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            playlistsController.delegate = self

            do {
                try playlistsController.performFetch()
                playlists = playlistsController.fetchedObjects ?? []
            } catch {
                debugPrint("Failed to fetch playlists!")
            }
        }

        func addBeer(to playlist: Playlist) {
            let beer = Beer(context: dataController.container.viewContext)
            beer.playlist = playlist
            beer.creationDate = Date()
            dataController.save()
        }

        func addPlaylist() {
            let playlist = Playlist(context: dataController.container.viewContext)
            playlist.isActive = true
            playlist.creationDate = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from playlist: Playlist) {
            let allBeers = playlist.sortedPlaylistBeers(using: sortOrder)
            // not deleting properly, look at later
            for offset in offsets {
                let beer = allBeers[offset]
                dataController.delete(beer)
                dataController.save()
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newPlaylists = controller.fetchedObjects as? [Playlist] {
                playlists = newPlaylists
            }
        }
    }
}
