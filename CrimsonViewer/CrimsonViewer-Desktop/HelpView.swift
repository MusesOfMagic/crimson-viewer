//
//  HelpView.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 28/09/2026.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 6) {
                Text("CrimsonViewer Help")
                    .font(.title)
                    .fontWeight(.semibold)

                Text("A lightweight Markdown viewer for macOS.")
                    .foregroundStyle(.secondary)
            }

            Divider()

            HelpSection(
                title: "Opening Markdown Files",
                text: """
                Choose File → Open, press ⌘O, or open a Markdown file \
                directly from Finder.
                """
            )

            HelpSection(
                title: "Multiple Documents",
                text: """
                Each Markdown document opens in its own window. \
                You can keep several documents open at the same time.
                """
            )

            HelpSection(
                title: "Finder Integration",
                text: """
                CrimsonViewer can be selected with Open With in Finder \
                and can be set as the default application for Markdown files.
                """
            )

            Divider()

            Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 8) {
                GridRow {
                    Text("Open File")
                    Text("⌘O")
                        .foregroundStyle(.secondary)
                }

                GridRow {
                    Text("Close Window")
                    Text("⌘W")
                        .foregroundStyle(.secondary)
                }

                GridRow {
                    Text("Find")
                    Text("⌘F")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.callout)

            Spacer()
        }
        .padding(30)
        .frame(width: 480, height: 440)
    }
}

private struct HelpSection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)

            Text(text)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
