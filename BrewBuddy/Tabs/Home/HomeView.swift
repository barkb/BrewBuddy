//
//  HomeView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//
import CoreData
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel

    static let tag: String? = "Home"

    var playlistRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        // This would be a spot to look into adding "categories" such as top
                        // rated, favorite brewery, and the like
                        LazyHGrid(rows: playlistRows) {
                            ForEach(viewModel.playlists) { playlist in
                                PlaylistSummaryView(playlist: playlist)
                            }
                        } // LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    } // Inner ScrollView
                    VStack(alignment: .leading) {
                        ListView(title: "Top Rated", beers: viewModel.topRated)
                        ListView(title: "More to Explore", beers: viewModel.moreToExplore)
                    } // Middle VStack
                    .padding(.horizontal)
                } // Topmost VStack
            } // Topmost ScrollView
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .toolbar {
                Button("Add Data", action: viewModel.addSampleData)
            }
        } // NavigationView
    } // body
} // end View

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
