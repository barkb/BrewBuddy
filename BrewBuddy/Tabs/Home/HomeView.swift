//
//  HomeView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//
import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    @EnvironmentObject var dataController: DataController
    @FetchRequest(
        entity: Playlist.entity(),
        sortDescriptors: [NSSortDescriptor(
                            keyPath: \Playlist.title,
                            ascending: true)
        ],
        predicate: NSPredicate(format: "isActive = true")
    ) var playlists: FetchedResults<Playlist>
    let beers: FetchRequest<Beer>

    var playlistRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init() {
        // Constructing a fetch request to show the 10 highest-rated, and favorite
        // beers from open playlists.
        let request: NSFetchRequest<Beer> = Beer.fetchRequest()
        let favoritedPredicate = NSPredicate(format: "favorited = true")
        let ratingPredicate = NSPredicate(format: "rating >= 4")
        let activePredicate = NSPredicate(format: "playlist.isActive = true")
        let compoundPredicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                activePredicate, favoritedPredicate, ratingPredicate
            ]
        )

        request.predicate = compoundPredicate
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Beer.rating, ascending: false)
        ]
        request.fetchLimit = 10
        beers = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        // This would be a spot to look into adding "categories" such as top
                        // rated, favorite brewery, and the like
//                        LazyHGrid(rows: playlistRows) {
//                            ForEach(playlists) { playlist in
//                                PlaylistSummaryView(playlist: playlist)
//                            }
//                        } // LazyHGrid
//                        .padding([.horizontal, .top])
//                        .fixedSize(horizontal: false, vertical: true)
                    } // Inner ScrollView
                    VStack(alignment: .leading) {
                        ListView(title: "Top Rated", beers: beers.wrappedValue.prefix(3))
                        ListView(title: "More to explore", beers: beers.wrappedValue.dropFirst(3))
                    } // Middle VStack
                    .padding(.horizontal)
                } // Topmost VStack
            } // Topmost ScrollView
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
        } // NavigationView
    } // body
} // end View

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
