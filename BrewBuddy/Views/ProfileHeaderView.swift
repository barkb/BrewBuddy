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
            VStack(alignment: .leading){
                Text(profile.profileTitle)
            }
            Spacer()
            NavigationLink(destination: EmptyView()) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(profile: Profile.example)
    }
}
