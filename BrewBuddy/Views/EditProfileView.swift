//
//  EditProfileView.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI

struct EditProfileView: View {
    let profile: Profile

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(profile: Profile) {
        self.profile = profile
        _title = State(wrappedValue: profile.profileTitle)
        _detail = State(wrappedValue: profile.profileDetail)
        _color = State(wrappedValue: profile.profileColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                // Bug exists where screen pops back up one navView on every key press
                TextField("Profile Name", text: $title.onChange(update))
                TextField("Profile Description", text: $detail.onChange(update))
            } // Section 1
            Section(header: Text("Custom profile color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Profile.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            } // Section 2
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a profile moves it from the Open to Closed tab; deleting it removes the profile entirely.")) {
                Button(profile.isActive ? "Close this profile" : "Reopen this profile") {
                    profile.isActive.toggle()
                    update()
                } // Close Button
                Button("Delete this profile") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        } // Form
        .navigationTitle("Edit Profile")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete Profile?"),
                message: Text("Are you sure you want to delete this profile? You will also delete all the beers it contains."), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    func update() {
        // profile.objectWillChange.send()
        profile.title = title
        profile.detail = detail
        profile.color = color
    }

    func delete() {
        dataController.delete(profile)
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(profile: Profile.example)
    }
}
