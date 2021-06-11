//
//  BrewBuddyUITests.swift
//  BrewBuddyUITests
//
//  Created by Ben Barkett on 6/10/21.
//

import XCTest

class BrewBuddyUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenTabAddsPlaylists() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...5 {
            app.buttons["add"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list rows.")
        }
    }

    func testAddingBeerInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list rows.")

        app.buttons["Add New Beer"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding a beer.")

    }

    func testEditingPlaylistUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["add"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list rows.")

        app.buttons["NEW PLAYLIST"].tap()
        app.textFields["Playlist Name"].tap()
        app.typeText(" 2")
//        app.keys["space"].tap()
//        app.keys["more"].tap()
//        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Playlists"].tap()
        XCTAssertTrue(app.buttons["NEW PLAYLIST 2"].exists, "The new playlist name should be visible in the list.")
    }

    func testEditingBeerUpdatesCorrectly() {
        testEditingPlaylistUpdatesCorrectly()
        app.buttons["Add New Beer"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows.")
        app.buttons["New Beer"].tap()
        app.textFields["Beer Name"].tap()
        app.keys["Space"].tap()
        app.keys["More"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Playlists"].tap()
        XCTAssertTrue(app.buttons["New Beer 2"].exists, "The new beer name should be visible in the list.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert showing for all awards.")

            app.buttons["OK"].tap()
        }
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
