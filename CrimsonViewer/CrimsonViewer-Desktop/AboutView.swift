//
//  AboutView.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI
import AppKit

struct AboutView: View {

    private var version: String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "1.0"
    }

    private var build: String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? "1"
    }

    var body: some View {
        VStack(spacing: 0) {

            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .shadow(
                    color: .red.opacity(0.18),
                    radius: 24
                )

            Text("CrimsonViewer")
                .font(.system(size: 28, weight: .semibold))

            Text("Lightweight Markdown viewer for macOS")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 5)

            Text("Version \(version) (\(build))")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.top, 10)

            Divider()
                .padding(.vertical, 22)

            VStack(spacing: 7) {
                Text("Built with SwiftUI and MarkdownUI")
                    .font(.callout)

                Text("Released under the MIT License")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                Text("© 2026 Muses of Magic")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 8)
            }
        }
        .frame(width: 400)
        .padding(.horizontal, 36)
        .padding(.top, 32)
        .padding(.bottom, 30)
    }
}
