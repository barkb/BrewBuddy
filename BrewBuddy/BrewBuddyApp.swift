//
//  BrewBuddyApp.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/19/20.
//

import SwiftUI

@main
struct BrewBuddyApp: App {
    @StateObject var dataController: DataController
    init() {
        /*
         Making custom object here and associating with Above state controller allows us to make custom
         Objects and only wrap them around State when we're ready too.
         
         Declaring StateObject above as var dataController = DataController() will cause problems later
         */
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
