//
//  BrewBuddyTests.swift
//  BrewBuddyTests
//
//  Created by Ben Barkett on 2/23/21.
//

import CoreData
import XCTest
@testable import BrewBuddy

class BaseTestCase: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }

}
