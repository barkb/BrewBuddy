//
//  CardRatingView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 10/27/21.
//

import SwiftUI

struct CardRatingView: View {
    @Binding var rating: Int

    var label = ""
    var maxRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow

    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            ForEach(1..<maxRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor : self.onColor)
                    .font(.system(size: 12))
            }
        }
    }

    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct CardRatingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardRatingView(rating: .constant(4))
            CardRatingView(rating: .constant(4))
        }
    }
}
