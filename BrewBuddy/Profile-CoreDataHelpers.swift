//
//  Profile-CoreDataHelpers.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/4/21.
//

import Foundation
import SwiftUI
extension Profile {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var profileTitle: String {
        title ?? NSLocalizedString("New Profile", comment: "Create a new profile")
    }
    
    var profileDetail: String {
        detail ?? ""
    }
    
    var profileColor: String {
        color ?? "Light Blue"
    }
    
    var profileBeers: [Beer] {
        beers?.allObjects as? [Beer] ?? []
        
    }
    
    var profileBeersDefaultSort: [Beer] {
        profileBeers.sorted {first, second in
            //First sort by whether beer is favorited
            if first.favorited {
                if !second.favorited {
                    return true
                }
            } else if !first.favorited {
                if second.favorited {
                    return false
                }
            }
            //If both are favorited or not then sort by higher rating
            if first.rating > second.rating {
                return true
            } else if first.rating < second.rating {
                return false
            }
            //If ratings are the same, then sort by creationdate
            return first.beerCreationDate < second.beerCreationDate
        }
    }
    
    var label: LocalizedStringKey {
        LocalizedStringKey("\(profileTitle), \(profileBeers.count) beers.")
    }
    
    static var example: Profile {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let profile = Profile(context: viewContext)
        profile.title = "Example Profile"
        profile.detail = "This is an example profile"
        profile.isActive = true
        profile.creationDate = Date()
        
        return profile
    }
    
    func sortedProfileBeers(using sortOrder: Beer.SortOrder) -> [Beer] {
        switch sortOrder {
        case .name:
            return profileBeers.sorted(by: \Beer.beerName)
        case .creationDate:
            return profileBeers.sorted(by: \Beer.beerCreationDate)
        case .brewery:
            return profileBeers.sorted(by: \Beer.beerBrewery)
        case .optimized:
            return profileBeersDefaultSort
        }
    }

}
