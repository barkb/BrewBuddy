//
//  Beer-CoreDataHelpers.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/4/21.
//

import Foundation

extension Beer {
    enum SortOrder {
        case optimized, creationDate, name, brewery
    }
    
    var beerName: String {
        name ?? NSLocalizedString("New Beer", comment: "Add a new beer")
    }
    
    var beerDetail: String {
        detail ?? ""
    }
    
    var beerCreationDate: Date {
        creationDate ?? Date()
    }
    
    var beerBrewery: String {
        brewery ?? ""
    }
    
    var beerType: String {
        type ?? ""
    }
    
    static var example: Beer {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let beer = Beer(context: viewContext)
        beer.name = "Example Beer"
        beer.detail = "This is an example Beer"
        beer.brewery = "Granville Brewing Co."
        beer.type = "Saison"
        beer.rating = 4
        beer.creationDate = Date()
        
        return beer
    }
}
