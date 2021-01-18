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
                            ForEach(profiles) { profile in
                                VStack(alignment: .leading) {
                                    Text("\(profile.profileBeers.count) beers")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(profile.profileTitle)
                                        .font(.title2)
                                } //Inner VStack
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 5)
                            } //ForEach
                        } //LazyHGrid
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    } //Inner ScrollView
                    VStack(alignment: .leading) {
                        list("Top Rated", for: beers.wrappedValue.prefix(3))
                        list("More to explore", for: beers.wrappedValue.dropFirst(3))
                    } // Middle VStack
                    .padding(.horizontal)
                } //Topmost VStack
            } //Topmost ScrollView
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        } //NavigationView
    } //body
    
    @ViewBuilder func list(_ title: String, for beers: FetchedResults<Beer>.SubSequence) -> some View {
            if beers.isEmpty {
                EmptyView()
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                ForEach(beers) { beer in
                    NavigationLink(destination: EditBeerView(beer: beer)) {
                        HStack(spacing: 20) {
                            Circle()
                                .stroke(Color(beer.profile?.profileTitle ?? "Light Blue"), lineWidth: 3)
                                .frame(width: 44, height: 44)
                            VStack(alignment: .leading) {
                                Text(beer.beerName)
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if beer.beerBrewery.isEmpty == false {
                                    Text(beer.beerBrewery)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondarySystemGroupedBackground)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }
                }
            }
        }
} //end View

//Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
