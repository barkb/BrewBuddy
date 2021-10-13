//
//  SettingsView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 6/11/21.
//

import SwiftUI

struct SettingsView: View {
    @State private var color: String

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(color: String) {
        _color = State(wrappedValue: color)
    }

    var body: some View {
        Form {
            Section(header: Text("Custom playlist color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Playlist.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            } // Section 2
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //SettingsView()
        Text("Hello, Settings.")
    }
}
