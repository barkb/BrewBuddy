//
//  ProfilesView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 12/29/20.
//

import SwiftUI

struct ProfilesView: View {
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
                    Section(header: Text(profile.profileTitle)){
                        ForEach(profile.allBeers) { beer in
                            BeerRowView(beer: beer)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showActiveProfiles ? "Open Profiles" : "Closed Projects")
        }
    }
}

struct ProfilesView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProfilesView(showActiveProfiles: true)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
