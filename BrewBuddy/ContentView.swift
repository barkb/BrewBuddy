//
//  ContentView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/19/20.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    private let newPlaylistActivity = "com.barkett.BrewBuddy.newPlaylist"

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            PlaylistsView(dataController: dataController, showActivePlaylists: true)
                .tag(PlaylistsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            PlaylistsView(dataController: dataController, showActivePlaylists: false)
                .tag(PlaylistsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }
        }
        .accentColor(Color("AccentColor"))
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newPlaylistActivity, perform: createPlaylist)
        .userActivity(newPlaylistActivity) { activity in
            activity.title = "New Playlist"
            activity.isEligibleForPrediction = true
        }
        .onOpenURL(perform: openURL)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }

    func openURL(_ url: URL) {
        selectedView = PlaylistsView.openTag
        dataController.addPlaylist()
    }

    func createPlaylist(_ userActivity: NSUserActivity) {
        selectedView = PlaylistsView.openTag
        dataController.addPlaylist()
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
