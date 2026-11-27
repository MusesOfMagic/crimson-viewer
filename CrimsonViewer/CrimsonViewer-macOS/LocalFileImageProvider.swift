//
//  LocalFileImageProvider.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI
import MarkdownUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

struct LocalFileImageProvider: ImageProvider {
    func makeImage(url: URL?) -> some View {
        LocalFileImageView(url: url)
    }
}

private struct LocalFileImageView: View {
    let url: URL?

    @ViewBuilder
    var body: some View {
        if let url {
            let resolvedURL = url.absoluteURL

            if resolvedURL.isFileURL {
                localImage(from: resolvedURL)
            } else {
                DefaultImageProvider.default
                    .makeImage(url: resolvedURL)
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func localImage(from url: URL) -> some View {
#if os(macOS)

        if let image = NSImage(contentsOf: url) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: image.size.width,
                    maxHeight: image.size.height,
                    alignment: .leading
                )
        }

#elseif os(iOS)

    if let image = loadLocalImage(from: url) {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(
                maxWidth: image.size.width,
                maxHeight: image.size.height,
                alignment: .leading
            )
    } else {
        Label(
            "Unable to load \(url.lastPathComponent)",
            systemImage: "photo.badge.exclamationmark"
        )
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding()
    }

#endif
    }
}

#if os(iOS)
private func loadLocalImage(from url: URL) -> UIImage? {
    var coordinationError: NSError?
    var image: UIImage?

    let coordinator = NSFileCoordinator()

    coordinator.coordinate(
        readingItemAt: url,
        options: [],
        error: &coordinationError
    ) { coordinatedURL in
        do {
            let data = try Data(contentsOf: coordinatedURL)
            image = UIImage(data: data)
        } catch {
            print("[ImageProvider] Error: \(error)")
        }
    }

    if let coordinationError {
        print("[ImageProvider] \(coordinationError)")
    }

    return image
}
#endif
