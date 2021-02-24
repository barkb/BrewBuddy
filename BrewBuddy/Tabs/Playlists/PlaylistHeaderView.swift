//
//  PlaylistHeaderView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct PlaylistHeaderView: View {
    @ObservedObject var playlist: Playlist

    var body: some View {
        HStack {
            Text(playlist.playlistTitle)
                .foregroundColor(Color(playlist.playlistColor))
            Spacer()
            NavigationLink(destination: EditPlaylistView(playlist: playlist)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .foregroundColor(Color(playlist.playlistColor))
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct PlaylistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistHeaderView(playlist: Playlist.example)
    }
}
