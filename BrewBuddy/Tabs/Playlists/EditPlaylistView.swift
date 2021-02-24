//
//  EditPlaylistView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct EditPlaylistView: View {
    let playlist: Playlist

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(playlist: Playlist) {
        self.playlist = playlist
        _title = State(wrappedValue: playlist.playlistTitle)
        _detail = State(wrappedValue: playlist.playlistDetail)
        _color = State(wrappedValue: playlist.playlistColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                // Bug exists where screen pops back up one navView on every key press
                TextField("Playlist Name", text: $title.onChange(update))
                TextField("Playlist Description", text: $detail.onChange(update))
            } // Section 1
            Section(header: Text("Custom playlist color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Playlist.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            } // Section 2
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a playlist moves it from the Open to Closed tab; deleting it removes the playlist entirely.")) {
                Button(playlist.isActive ? "Close this playlist" : "Reopen this playlist") {
                    playlist.isActive.toggle()
                    update()
                } // Close Button
                Button("Delete this playlist") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        } // Form
        .navigationTitle("Edit Playlist")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete Playlist?"),
                message: Text("Are you sure you want to delete this playlist? You will also delete all the beers it contains."), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    func update() {
        // playlist.objectWillChange.send()
        playlist.title = title
        playlist.detail = detail
        playlist.color = color
    }

    func delete() {
        dataController.delete(playlist)
        presentationMode.wrappedValue.dismiss()
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
            update()
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

struct EditPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlaylistView(playlist: Playlist.example)
    }
}
