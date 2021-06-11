//
//  PlaylistSummaryView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/24/21.
//

import SwiftUI

struct PlaylistSummaryView: View {
    @ObservedObject var playlist: Playlist
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(playlist.playlistBeers.count) beers")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(playlist.playlistTitle)
                .font(.title2)
        } // Inner VStack
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(playlist.label)
    }
}

struct PlaylistSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistSummaryView(playlist: Playlist.example)
    }
}
