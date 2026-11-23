//
//  ContentView.swift
//  CrimsonViewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    let document: MarkdownDocument

    @Environment(\.documentConfiguration)
    private var documentConfiguration
    
    @Environment(\.openDocument) private var openDocument

    @State private var isDropTargeted = false
    @State private var dropError: String?

    var body: some View {
        MarkdownView(markdown: document.text,
                     baseURL: documentConfiguration?
                        .fileURL?
                        .deletingLastPathComponent()
                    )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay {
                if isDropTargeted {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color.accentColor,
                            lineWidth: 3
                        )
                        .padding(8)
                        .allowsHitTesting(false)
                }
            }
            .dropDestination(for: URL.self) { urls, _ in
                openDroppedFiles(urls)
            }
            .dropConfiguration { _ in
                DropConfiguration(operation: .copy)
            }
            .onDropSessionUpdated { session in
                switch session.phase {
                case .entering, .active:
                    isDropTargeted = true

                case .exiting,
                     .dataTransferCompleted,
                     .ended:
                    isDropTargeted = false

                @unknown default:
                    isDropTargeted = false
                }
            }
            .alert(
                "Unable to Open File",
                isPresented: Binding(
                    get: { dropError != nil },
                    set: { if !$0 { dropError = nil } }
                )
            ) {
                Button("OK") {
                    dropError = nil
                }
            } message: {
                Text(dropError ?? "")
            }
    }

    private func openDroppedFiles(_ urls: [URL]) {
        let markdownFiles = urls.filter(isMarkdownFile)

        guard !markdownFiles.isEmpty else {
            return
        }

        Task {
            for url in markdownFiles {
                do {
                    try await openDocument(at: url)
                } catch {
                    dropError = error.localizedDescription
                }
            }
        }
    }

    private func isMarkdownFile(_ url: URL) -> Bool {
        if let values = try? url.resourceValues(
            forKeys: [.contentTypeKey]
        ),
           let contentType = values.contentType {
            return contentType.conforms(to: .markdown)
        }

        return ["md", "markdown"]
            .contains(url.pathExtension.lowercased())
    }
}
