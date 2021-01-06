//
//  ProfileHeaderView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var profile: Profile
    
    var body: some View {
        HStack{
            Text(profile.profileTitle)
                .accentColor(Color(profile.projectColor))
            NavigationLink(destination: EmptyView()) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .accentColor(Color(profile.projectColor))
            }
        }
        .padding(.bottom, 10)
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(profile: Profile.example)
    }
}
