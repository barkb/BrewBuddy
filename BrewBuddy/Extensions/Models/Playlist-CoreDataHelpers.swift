//
//  Playlist-CoreDataHelpers.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/4/21.
//

import Foundation
import SwiftUI
extension Playlist {
    static let colors = [
        "Pink",
        "Purple",
        "Red",
        "Orange",
        "Gold",
        "Green",
        "Teal",
        "Light Blue",
        "Dark Blue",
        "Midnight",
        "Dark Gray",
        "Gray"
    ]

    var playlistTitle: String {
        title ?? NSLocalizedString("New Playlist", comment: "Create a new playlist")
    }

    var playlistDetail: String {
        detail ?? ""
    }

    var playlistColor: String {
        color ?? "Light Blue"
    }

    var playlistBeers: [Beer] {
        beers?.allObjects as? [Beer] ?? []
    }

    var playlistBeersDefaultSort: [Beer] {
        playlistBeers.sorted {first, second in
            // First sort by whether beer is favorited
            if first.favorited {
                if !second.favorited {
                    return true
                }
            } else if !first.favorited {
                if second.favorited {
                    return false
                }
            }
            // If both are favorited or not then sort by higher rating
            if first.rating > second.rating {
                return true
            } else if first.rating < second.rating {
                return false
            }
            // If ratings are the same, then sort by creationdate
            return first.beerCreationDate < second.beerCreationDate
        }
    }

    var label: LocalizedStringKey {
        LocalizedStringKey("\(playlistTitle), \(playlistBeers.count) beers.")
    }

    static var example: Playlist {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let playlist = Playlist(context: viewContext)
        playlist.title = "Example Playlist"
        playlist.detail = "This is an example playlist"
        playlist.isActive = true
        playlist.creationDate = Date()

        return playlist
    }

    func sortedPlaylistBeers(using sortOrder: Beer.SortOrder) -> [Beer] {
        switch sortOrder {
        case .name:
            return playlistBeers.sorted(by: \Beer.beerName)
        case .creationDate:
            return playlistBeers.sorted(by: \Beer.beerCreationDate)
        case .brewery:
            return playlistBeers.sorted(by: \Beer.beerBrewery)
        case .optimized:
            return playlistBeersDefaultSort
        }
    }
}
