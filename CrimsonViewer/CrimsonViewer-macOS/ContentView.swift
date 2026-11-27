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

#if os(iOS)
    @State private var isFolderPickerPresented = false
    @State private var folderAccess: ImageFolderAccess?
#endif
    
#if os(macOS)
    @Environment(\.openDocument)
    private var openDocument

    @State private var isDropTargeted = false
    @State private var dropError: String?
#endif

    var body: some View {
#if os(macOS)
        markdownView
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
                    set: {
                        if !$0 {
                            dropError = nil
                        }
                    }
                )
            ) {
                Button("OK") {
                    dropError = nil
                }
            } message: {
                Text(dropError ?? "")
            }
#else
    markdownView
        .id(folderAccess?.id)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isFolderPickerPresented = true
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
                .help("Grant Folder Access")
                .accessibilityLabel("Grant Folder Access")
            }
        }
        .fileImporter(
            isPresented: $isFolderPickerPresented,
            allowedContentTypes: [.folder]
        ) { result in
            switch result {
            case .success(let url):
                grantFolderAccess(url)

            case .failure(let error):
                print("[FolderAccess] Error: \(error)")
            }
        }
        .task(id: documentFolderURL) {
            restoreFolderAccess()
        }
#endif
    }
    
    private var documentFolderURL: URL? {
        documentConfiguration?
            .fileURL?
            .deletingLastPathComponent()
    }

    private var markdownView: some View {
        MarkdownView(
            markdown: document.text,
            baseURL: documentFolderURL
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
    
#if os(macOS)
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
#endif
    
#if os(iOS)
    private func grantFolderAccess(_ url: URL) {
        guard let access = ImageFolderAccess(url: url) else {
            print("[FolderAccess] Permission denied")
            return
        }

        folderAccess = access

        do {
            try FolderAccessManager.remember(access)
        } catch {
            print("[FolderAccess] Unable to save bookmark: \(error)")
        }
    }
#endif
    
#if os(iOS)
    private func restoreFolderAccess() {
        guard let directory = documentFolderURL else {
            folderAccess = nil
            return
        }

        folderAccess = FolderAccessManager.restore(
            for: directory
        )
    }
#endif
}
