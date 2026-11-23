//
//  HelpCommands.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI

struct HelpCommands: Commands {
    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button("CrimsonViewer Help") {
                openWindow(id: "help")
            }
        }
    }
}
