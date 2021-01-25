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
    @FetchRequest(entity: Profile.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Profile.title, ascending: true)], predicate: NSPredicate(format: "isActive = true")) var profiles: FetchedResults<Profile>
    let beers: FetchRequest<Beer>
    
    var profileRows: [GridItem] {
        [GridItem(.fixed(100))]
    }
    
    init() {
        let request: NSFetchRequest<Beer> = Beer.fetchRequest()
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
                        //This would be a spot to look into adding "categories" such as top rated, favorite brewery, and the like
                        LazyHGrid(rows: profileRows) {
                            ForEach(profiles, content: ProfileSummaryView.init)
                        } //LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    } //Inner ScrollView
                    VStack(alignment: .leading) {
                        ListView(title: "Top Rated", beers: beers.wrappedValue.prefix(3))
                        ListView(title: "More to explore", beers: beers.wrappedValue.dropFirst(3))
                    } // Middle VStack
                    .padding(.horizontal)
                } //Topmost VStack
            } //Topmost ScrollView
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        } //NavigationView
    } //body
} //end View

//Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
