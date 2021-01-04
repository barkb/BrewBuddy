//
//  ContentView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/19/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ProfilesView(showActiveProfiles: true)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            ProfilesView(showActiveProfiles: false)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
