//
//  Binding-OnChange.swift
//  BrewBuddy
//
//  Created by Ben Barkett on 1/6/21.
//

import SwiftUI
extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: {self.wrappedValue},
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
