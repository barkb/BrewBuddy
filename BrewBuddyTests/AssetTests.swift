//
//  AssetTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 2/24/21.
//

import XCTest
@testable import BrewBuddy

class AssetTests: XCTestCase {
    func testColorsExist() {
        for color in Playlist.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
