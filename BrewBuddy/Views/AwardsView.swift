//
//  AwardsView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/15/21.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            //No Action Yet
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.secondary.opacity(0.5))
                        } //Button
                    } //ForEach
                } //LazyVGrid
            } //ScrollView
            .navigationTitle("Awards")
        } // navigation view
    } //body
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}
