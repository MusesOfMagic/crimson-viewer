//
//  CrimsonViewer_iOSApp.swift
//  CrimsonViewer iOS
//
//  Created by Muses of Magic on 25/11/2026.
//

import SwiftUI

@main
struct CrimsonViewerIOSApp: App {
    var body: some Scene {
        DocumentGroup { document in
            ContentView(document: document)
        } makeReadableDocument: { _, _ in
            MarkdownDocument()
        }
        .commands {
            SearchCommands()
        }
    }
}
