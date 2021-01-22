//
//  EditBeerView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/5/21.
//

import SwiftUI

struct EditBeerView: View {
    let beer: Beer
    @EnvironmentObject var dataController: DataController
    
    @State private var name: String
    @State private var detail: String
    @State private var type: String
    @State private var brewery: String
    @State private var rating: Int
    @State private var abv: String
    @State private var ibu: String
    @State private var favorited: Bool
    
    init(beer: Beer) {
        self.beer = beer
        _name = State(wrappedValue: beer.beerName)
        _detail = State(wrappedValue: beer.beerDetail)
        _type = State(wrappedValue: beer.beerType)
        _brewery = State(wrappedValue: beer.beerBrewery)
        _rating = State(wrappedValue: Int(beer.rating))
        _abv = State(wrappedValue: String(beer.abv))
        _ibu = State(wrappedValue: String(beer.ibu))
        _favorited = State(wrappedValue: beer.favorited)
        
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic Attributes")) {
                TextField("Beer Name", text: $name.onChange(update))
                TextField("Brewery", text: $brewery.onChange(update))
                TextField("Beer Type", text: $type.onChange(update))
            }
            Section(header: Text("Advanced Attributes")) {
                TextField("ABV: ", text:$abv.onChange(update))
                    .keyboardType(.decimalPad)
                TextField("IBU: ", text:$ibu.onChange(update))
                    .keyboardType(.numberPad)
//                Stepper("ABV: \(abv, specifier: "%.1f")") {
//                    abv += 0.1
//                } onDecrement: {
//                    abv -= 0.1
//                }
//
//                Stepper("IBU: \(ibu)") {
//                    ibu += 1
//                } onDecrement: {
//                    ibu -= 1
//                }
            }
            
            Section(header: Text("Rating")) {
                RatingView(rating: $rating.onChange(update))
                Toggle(isOn: $favorited.onChange(update)) {
                    Text("Mark as Favorite:")
                }
            }
            
            Section(header: Text("Additional Notes")) {
                TextField("Description" ,text: $detail.onChange(update))
            }
        }
        .navigationTitle("Edit Beer")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        beer.profile?.objectWillChange.send()
        
        beer.name = name
        beer.detail = detail
        beer.brewery = brewery
        beer.type = type
        beer.rating = Int16(rating)
        beer.abv = Double(abv) ?? 0.0
        beer.ibu = Int16(ibu) ?? 0
        beer.favorited = favorited
    }
}

struct EditBeerView_Previews: PreviewProvider {
    static var previews: some View {
        EditBeerView(beer: Beer.example)
    }
}
