//
//  Profile-CoreDataHelpers.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/4/21.
//

import Foundation

extension Profile {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var profileTitle: String {
        title ?? ""
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
            if first.rating > second.rating {
                return true
            } else if first.rating < second.rating {
                return false
            }
            return first.beerCreationDate < second.beerCreationDate
        }
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
    

}
