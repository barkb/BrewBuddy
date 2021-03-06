//
//  BeerRowView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct BeerRowView: View {
    @ObservedObject var playlist: Playlist
    @ObservedObject var beer: Beer

    var icon: some View {
        if beer.favorited {
            return Image(systemName: "star.fill")
                .foregroundColor(Color("Gold"))
        } else if beer.rating == 5 {
            return Image(systemName: "die.face.5")
                .foregroundColor(Color(playlist.playlistColor))
        } else if beer.rating == 4 {
            return Image(systemName: "die.face.4")
                .foregroundColor(Color(playlist.playlistColor))
        } else if beer.rating == 3 {
            return Image(systemName: "die.face.3")
                .foregroundColor(Color(playlist.playlistColor))
        } else if beer.rating == 2 {
            return Image(systemName: "die.face.2")
                .foregroundColor(Color(playlist.playlistColor))
        } else if beer.rating == 1 {
            return Image(systemName: "die.face.1")
                .foregroundColor(Color(playlist.playlistColor))
        } else {
            return Image(systemName: "star.fill")
                .foregroundColor(.clear)
        }
    }

    var label: Text {
        if beer.favorited {
            return Text("\(beer.beerName), favorited.")
        } else {
            return Text("\(beer.beerName)")
        }
    }

    var body: some View {
        NavigationLink(destination: EditBeerView(beer: beer)) {
            Label {
                Text(beer.beerName)
            } icon: {
                icon
            }
        }
        .accessibility(label: label)
    }
}

struct BeerRowView_Previews: PreviewProvider {
    static var previews: some View {
        BeerRowView(playlist: Playlist.example, beer: Beer.example)
    }
}
