//
//  HomeView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/28/20.
//
import CoreData
import CoreSpotlight
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
                if let beer = viewModel.selectedBeer {
                    NavigationLink(
                        destination: EditBeerView(beer: beer),
                        tag: beer,
                        selection: $viewModel.selectedBeer,
                        label: EmptyView.init
                    )
                    .id(beer)
                }
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
            .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
        } // NavigationView
    } // body

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            viewModel.selectBeer(with: uniqueIdentifier)
        }
    }
} // end View

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
