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
        HStack {
            Text(profile.profileTitle)
                .foregroundColor(Color(profile.profileColor))
            Spacer()
            NavigationLink(destination: EditProfileView(profile: profile)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .foregroundColor(Color(profile.profileColor))
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(profile: Profile.example)
    }
}
