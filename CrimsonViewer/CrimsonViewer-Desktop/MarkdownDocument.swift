//
//  MarkdownDocument.swift
//  CrimsonViewer
//
//  Created by Helga Moore on 28/09/2026.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
final class MarkdownDocument: ReadableDocument {
    static let readableContentTypes: [UTType] = [
        .markdown
    ]

    var text: String = ""

    func reader(
        configuration: sending ReadConfiguration
    ) -> sending FileWrapperDocumentReader<String> {
        FileWrapperDocumentReader(configuration) { fileWrapper in
            guard let data = fileWrapper.regularFileContents else {
                throw CocoaError(.fileReadCorruptFile)
            }

            return String(decoding: data, as: UTF8.self)
        }
    }

    @MainActor
    func apply(
        snapshot: sending String,
        previous: sending String?
    ) async throws {
        text = snapshot
    }
}
