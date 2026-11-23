//
//  Untitled.swift
//  Crimson Viewer
//
//  Created by Helga Moore on 29/09/2026.
//

import SwiftUI

struct CrimsonSearchActions {
    let show: () -> Void
    let next: () -> Void
    let previous: () -> Void
}

private struct CrimsonSearchActionsKey:
    FocusedValueKey {

    typealias Value = CrimsonSearchActions
}

extension FocusedValues {
    var crimsonSearchActions: CrimsonSearchActions? {
        get {
            self[CrimsonSearchActionsKey.self]
        }

        set {
            self[CrimsonSearchActionsKey.self] = newValue
        }
    }
}

struct SearchCommands: Commands {
    @FocusedValue(\.crimsonSearchActions)
    private var searchActions

    var body: some Commands {
        CommandGroup(before: .textEditing) {
            Button("Find…") {
                searchActions?.show()
            }
            .keyboardShortcut("f")

            Button("Find Next") {
                searchActions?.next()
            }
            .keyboardShortcut("g")

            Button("Find Previous") {
                searchActions?.previous()
            }
            .keyboardShortcut(
                "g",
                modifiers: [.command, .shift]
            )

            Divider()
        }
    }
}
