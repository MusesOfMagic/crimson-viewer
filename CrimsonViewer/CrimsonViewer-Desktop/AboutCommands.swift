//
//  AboutCommands.swift
//  Crimson Viewer
//
//  Created by Helga Moore on 28/09/2026.
//

import SwiftUI

struct AboutCommands: Commands {

    @Environment(\.openWindow) private var openWindow

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About CrimsonViewer") {
                openWindow(id: "about")
            }
        }
    }
}
