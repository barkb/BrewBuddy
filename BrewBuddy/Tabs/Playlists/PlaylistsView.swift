//
//  PlaylistsView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/29/20.
//

import SwiftUI

struct PlaylistsView: View {
    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    init(dataController: DataController, showActivePlaylists: Bool) {
        let viewModel = ViewModel(dataController: dataController, showActivePlaylists: showActivePlaylists)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var playlistsList: some View {
        List {
            ForEach(viewModel.playlists) { playlist in
                Section(header: PlaylistHeaderView(playlist: playlist)) {
                    ForEach(playlist.sortedPlaylistBeers(using: viewModel.sortOrder)) { beer in
                        BeerRowView(playlist: playlist, beer: beer)
                    } // inner ForEach
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: playlist)
                    } // onDelete
                    if viewModel.showActivePlaylists {
                        Button {
                            withAnimation {
                                viewModel.addBeer(to: playlist)
                            }
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
            if viewModel.showActivePlaylists == true {
                Button {
                    withAnimation {
                        viewModel.addPlaylist()
                    }
                } label: {
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
                if viewModel.playlists.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    playlistsList
                } // end If
            } // Group
            .navigationTitle(viewModel.showActivePlaylists ? "Open Playlists" : "Closed Playlists")
            .toolbar {
                addPlaylistToolbarItem
                sortOrderToolbarItem
            } // toolbar
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Beers"), message: nil, buttons: [
                    .default(Text("Optimized")) {viewModel.sortOrder = .optimized},
                    .default(Text("Creation Date")) {viewModel.sortOrder = .creationDate},
                    .default(Text("Name")) {viewModel.sortOrder = .name},
                    .default(Text("Brewery")) {viewModel.sortOrder = .brewery}
                ])
            } // action sheet
            // If none of the above views are selected, show SelectSomethingView()
            SelectSomethingView()
        } // NavigationView
    } // body view
} // PlaylistsView

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView(dataController: DataController.preview, showActivePlaylists: true)
    }
}
