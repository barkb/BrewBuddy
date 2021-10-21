//
//  ListView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/24/21.
//

import SwiftUI

struct ListView: View {
    let title: LocalizedStringKey
    let beers: ArraySlice<Beer>

    var body: some View {
        if beers.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            ForEach(beers) { beer in
                NavigationLink(destination: EditBeerView(beer: beer)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(beer.playlist?.playlistColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)
                        VStack(alignment: .leading) {
                            Text(beer.beerName)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            if beer.beerBrewery.isEmpty == false {
                                Text(beer.beerBrewery)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}

// struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
// }
