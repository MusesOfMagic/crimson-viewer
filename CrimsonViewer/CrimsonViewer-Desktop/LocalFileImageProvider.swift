//
//  LocalFileImageProvider.swift
//  Crimson Viewer
//
//  Created by Helga Moore on 28/09/2026.
//

import SwiftUI
import AppKit
import MarkdownUI

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
        if let image = NSImage(contentsOf: url) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(
                    maxWidth: image.size.width,
                    maxHeight: image.size.height,
                    alignment: .leading
                )
        } else {
            EmptyView()
        }
    }
}
