//
//  DevelopmentTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 3/1/21.
//
import CoreData
import XCTest
@testable import BrewBuddy

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Playlist.fetchRequest()), 5, "There should be 5 sample playlists.")
        XCTAssertEqual(dataController.count(for: Beer.fetchRequest()), 50, "There should be 50 sample beers.")
    }

    func testDeleteAllWorks() throws {
        try dataController.createSampleData()
        dataController.deleteAll()
        XCTAssertEqual(dataController.count(for: Playlist.fetchRequest()), 0, "There should be 0 playlists after deletion.")
        XCTAssertEqual(dataController.count(for: Beer.fetchRequest()), 0, "There should be 0 beers after deletion.")
    }

    func testExamplePlaylistIsClosed() {
        let playlist = Playlist.example
        XCTAssertFalse(playlist.isActive, "The example playlist should not be active.")
    }

    func testExampleBeerIsHighRating() {
        let beer = Beer.example
        XCTAssertGreaterThan(beer.rating, 3, "The example beer should have a rating higher than 3.")
    }
}
