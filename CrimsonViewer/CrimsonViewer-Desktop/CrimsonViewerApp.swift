//
//  CrimsonViewerApp.swift
//  CrimsonViewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI

@main
struct CrimsonViewerApp: App {
    var body: some Scene {
        DocumentGroup { document in
            ContentView(document: document)
        } makeReadableDocument: { configuration, context in
            MarkdownDocument()
        }
        .defaultSize(
            width: defaultDocumentSize.width,
            height: defaultDocumentSize.height
        )
        .commands {
            AboutCommands()
            HelpCommands()
            SearchCommands()
        }

        Window("About CrimsonViewer", id: "about") {
            AboutView()
        }
        .windowResizability(.contentSize)
        
        Window("CrimsonViewer Help", id: "help") {
            HelpView()
        }
        .windowResizability(.contentSize)
    }
    
    private var defaultDocumentSize: CGSize {
        let visibleHeight = NSScreen.main?.visibleFrame.height ?? 900

        let height = min(
            max(visibleHeight * 0.8, 650),
            1000
        )
        let width = height / sqrt(2)

        return CGSize(width: width, height: height)
    }
}
