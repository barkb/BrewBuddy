//
//  Profile-CoreDataHelpers.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/4/21.
//

import Foundation

extension Profile {
    var profileTitle: String {
        title ?? ""
    }
    
    var profileDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var allBeers: [Beer] {
        let beersArray = beers?.allObjects as? [Beer] ?? []
        return beersArray
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
