//
//  AwardTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 2/24/21.
//
import CoreData
import XCTest
@testable import BrewBuddy

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always equal its name.")
        }
    }

    func testZeroAwardsForNewUser() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New user has earned an award they should not have.")
        }
    }

    func testAddingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {

            for _ in 0..<value {
                _ = Beer(context: managedObjectContext)
            }

            let matches = awards.filter { award in
                award.criterion == "beers" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count+1, "Adding \(value) beers should unlock \(count+1) awards.")

            dataController.deleteAll()
        }
    }

    func testFavoritedItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                let beer = Beer(context: managedObjectContext)
                beer.favorited = true
            }

            let matches = awards.filter { award in
                award.criterion == "favorite" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count+1, "Favoriting \(value) beers should unlock \(count+1) awards.")

            dataController.deleteAll()
        }
    }
}
