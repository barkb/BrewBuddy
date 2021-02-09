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
                .onReceive(
                    // Automatically save when we detect that we are no longer
                    // the foreground app. Use this rather than the scene phase API
                    // so we can port to macOS, where scene phase wont detect out app
                    // losing focus as of macOS 11.1
                    NotificationCenter.default.publisher(
                    for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
