//
//  TopRatedGridCardView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 10/26/21.
//

import SwiftUI

struct TopRatedGridCardView: View {
    let beer: Beer
    @State private var rating: Int

    init(beer: Beer) {
        self.beer = beer
        _rating = State(wrappedValue: Int(beer.rating))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(beer.beerName)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding([.top, .leading, .trailing])
            Text(beer.beerBrewery)
                .foregroundColor(.white)
                .padding([.leading, .trailing])
            CardRatingView(rating: $rating)
                .padding([.bottom, .leading, .trailing])
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(beer.playlist?.playlistColor ?? "Light Blue"))
        )
    }
}

struct TopRatedGridCardView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedGridCardView(beer: Beer.example)
    }
}
