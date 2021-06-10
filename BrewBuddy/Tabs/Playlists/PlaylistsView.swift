//
//  PlaylistsView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/29/20.
//

import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var showingSortOrder = false
    @State private var sortOrder = Beer.SortOrder.optimized

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    let showActivePlaylists: Bool
    let playlists: FetchRequest<Playlist>

    init(showActivePlaylists: Bool) {
        self.showActivePlaylists = showActivePlaylists
        playlists = FetchRequest<Playlist>(
            entity: Playlist.entity(),
            sortDescriptors: [NSSortDescriptor(
                                keyPath: \Playlist.creationDate,
                                ascending: false)],
            predicate: NSPredicate(format: "isActive = %d", showActivePlaylists)
        )
    }

    var playlistsList: some View {
        List {
            ForEach(playlists.wrappedValue) { playlist in
                Section(header: PlaylistHeaderView(playlist: playlist)) {
                    ForEach(playlist.sortedPlaylistBeers(using: sortOrder)) { beer in
                        BeerRowView(playlist: playlist, beer: beer)
                    } // inner ForEach
                    .onDelete { offsets in
                        delete(offsets, from: playlist)
                    } // onDelete
                    if showActivePlaylists {
                        Button {
                            addBeer(to: playlist)
                        } label: {
                            Label("Add New Beer", systemImage: "plus")
                        } // Button
                    } // showActivePlaylists If
                } // Section
            } // Outer ForEach
        } // List
        .listStyle(InsetGroupedListStyle())
    } // playlistsList

    var addPlaylistToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            // Need to debug later, new playlist not sliding in??
            // Might delete later, depending on what is done with playlists
            if showActivePlaylists == true {
                Button(action: addPlaylist) {
                    // in iOS 14.3 VoiceOver has a bug that reads the label "Add Playlist"
                    // as "Add" regardless of what accessibility label we give it due to
                    // the "plus" systemImage. Therefore, when VoiceOver is running
                    // we use a text view as the button instead so VoiceOver reads it
                    // correctly.
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Playlist")
                    } else {
                        Label("Add Playlist", systemImage: "plus")
                    }
                } // button
            } // if showActivePlaylists
        } // ToolbarItem
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            } // button
        } // ToolbarItem
    }

    var body: some View {
        NavigationView {
            Group {
                if playlists.wrappedValue.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    playlistsList
                } // end If
            } // Group
            .navigationTitle(showActivePlaylists ? "Open Playlists" : "Closed Playlists")
            .toolbar {
                addPlaylistToolbarItem
                sortOrderToolbarItem
            } // toolbar
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Beers"), message: nil, buttons: [
                    .default(Text("Optimized")) {sortOrder = .optimized},
                    .default(Text("Creation Date")) {sortOrder = .creationDate},
                    .default(Text("Name")) {sortOrder = .name},
                    .default(Text("Brewery")) {sortOrder = .brewery}
                ])
            } // action sheet
            // If none of the above views are selected, show SelectSomethingView()
            SelectSomethingView()
        } // NavigationView
    } // body view

    func addBeer(to playlist: Playlist) {
        withAnimation {
            let beer = Beer(context: managedObjectContext)
            beer.playlist = playlist
            beer.creationDate = Date()
            dataController.save()
        }
    }

    func addPlaylist() {
        withAnimation {
            let playlist = Playlist(context: managedObjectContext)
            debugPrint(playlist)
            playlist.isActive = true
            playlist.creationDate = Date()
            debugPrint(playlist)
            dataController.save()
            debugPrint(playlists.wrappedValue)
        }
    }

    func delete(_ offsets: IndexSet, from playlist: Playlist) {
        let allBeers = playlist.sortedPlaylistBeers(using: sortOrder)
        // not deleting properly, look at later
        for offset in offsets {
            let beer = allBeers[offset]
            dataController.delete(beer)
            dataController.save()
        }
    }
} // PlaylistsView

struct PlaylistsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        PlaylistsView(showActivePlaylists: true)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
