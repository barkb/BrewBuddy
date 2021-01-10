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
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(profile: Profile){
        self.profile = profile
        _title = State(wrappedValue: profile.profileTitle)
        _detail = State(wrappedValue: profile.profileDetail)
        _color = State(wrappedValue: profile.profileColor)
    }
    
    var body: some View {
        Form{
            Section(header: Text("Basic Settings")) {
                TextField("Profile Name", text: $title.onChange(update))
                TextField("Profile Description", text: $detail.onChange(update))
            }
            
            Section(header: Text("Custom profile color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Profile.colors, id: \.self){item in
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
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Edit Profile")
        .onDisappear(perform: update)
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        profile.objectWillChange.send()
        profile.title = title
        profile.detail = detail
        profile.color = color
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(profile: Profile.example)
    }
}
