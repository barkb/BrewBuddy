//
//  PerformanceTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 6/10/21.
//

import XCTest
@testable import BrewBuddy

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        for _ in 1...100 {
            try dataController.createSampleData()
        }
        let awards = Array(repeating: Award.allAwards, count: 25).joined()

        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
