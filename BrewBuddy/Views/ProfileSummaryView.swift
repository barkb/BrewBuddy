//
//  ProfileSummaryView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/24/21.
//

import SwiftUI

struct ProfileSummaryView: View {
    @ObservedObject var profile: Profile
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(profile.profileBeers.count) beers")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(profile.profileTitle)
                .font(.title2)
        } // Inner VStack
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        accessibilityLabel(profile.label)
    }
}

struct ProfileSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummaryView(profile: Profile.example)
    }
}
