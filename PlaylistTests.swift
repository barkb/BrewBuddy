//
//  PlaylistTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 2/24/21.
//
import CoreData
import XCTest
@testable import BrewBuddy

class PlaylistTests: BaseTestCase {
    func testCreatingPlaylistsAndBeers() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let playlist = Playlist(context: managedObjectContext)
            for _ in 0..<targetCount {
                let beer = Beer(context: managedObjectContext)
                beer.playlist = playlist
            }
        }

        XCTAssertEqual(dataController.count(for: Playlist.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Beer.fetchRequest()), targetCount*targetCount)
    }

    func testDeletingPlaylistCascadeDeletesBeers() throws {
        try dataController.createSampleData()
        let request = NSFetchRequest<Playlist>(entityName: "Playlist")
        let playlists = try managedObjectContext.fetch(request)

        dataController.delete(playlists[0])

        XCTAssertEqual(dataController.count(for: Playlist.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Beer.fetchRequest()), 40)
    }
}
