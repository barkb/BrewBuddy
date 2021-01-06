//
//  BeerRowView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct BeerRowView: View {
    @ObservedObject var beer: Beer
    var body: some View {
        NavigationLink(
            destination: EditBeerView(beer: beer),
            label: {
                Text(beer.beerName)
            })
    }
}

struct BeerRowView_Previews: PreviewProvider {
    static var previews: some View {
        BeerRowView(beer: Beer.example)
    }
}
