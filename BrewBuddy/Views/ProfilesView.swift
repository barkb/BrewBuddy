//
//  ProfilesView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/29/20.
//

import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Beer.SortOrder.optimized
    
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    let showActiveProfiles: Bool
    let profiles: FetchRequest<Profile>
    
    init(showActiveProfiles: Bool) {
        self.showActiveProfiles = showActiveProfiles
        profiles = FetchRequest<Profile>(entity: Profile.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Profile.creationDate, ascending: false)], predicate: NSPredicate(format: "isActive = %d"))
    }
    
    var body: some View {
        NavigationView{
            List {
                ForEach(profiles.wrappedValue) { profile in
                    Section(header: ProfileHeaderView(profile: profile)){
                        ForEach(beers(for: profile)) { beer in
                            BeerRowView(beer: beer)
                        }
                        .onDelete{offsets in
                            //not deleting properly, look at later
                            for offset in offsets {
                                let item = profile.profileBeers[offset]
                                dataController.delete(item)
                                dataController.save()
                            }
                        }
                        if showActiveProfiles {
                            Button{
                                withAnimation{
                                    let beer = Beer(context: managedObjectContext)
                                    beer.profile = profile
                                    beer.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Beer", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showActiveProfiles ? "Open Profiles" : "Closed Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //Need to debug later, new profile not sliding in??
                    //Might delete later, depending on what is done with profiles
                    if showActiveProfiles {
                        Button {
                            withAnimation {
                                let profile = Profile(context: managedObjectContext)
                                profile.isActive = true
                                profile.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Profile", systemImage: "plus")
                        }//button
                    }//if showActiveProfiles
                }//first toolbaritem
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }//button
                }//second toolbaritem
                
            }//toolbar
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort Beers"), message: nil, buttons: [
                    .default(Text("Optimized")) {sortOrder = .optimized},
                    .default(Text("Creation Date")) {sortOrder = .creationDate},
                    .default(Text("Name")) {sortOrder = .name},
                    .default(Text("Brewery")) {sortOrder = .brewery}
                ])
            }//action sheet
        }//NavigationView
    }//body view
    
    func beers(for profile: Profile) -> [Beer] {
        switch sortOrder {
        case .name:
            return profile.profileBeers.sorted(by: \Beer.beerName)
        case .creationDate:
            return profile.profileBeers.sorted(by: \Beer.beerCreationDate)
        case .brewery:
            return profile.profileBeers.sorted(by: \Beer.beerBrewery)
        case .optimized:
            return profile.profileBeersDefaultSort
        }
    }
    
}//ProfilesView

struct ProfilesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProfilesView(showActiveProfiles: true)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
