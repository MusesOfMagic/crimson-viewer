//
//  MarkdownView.swift
//  CrimsonViewer
//
//  Created by Helga Moore on 28/09/2026.
//

import SwiftUI
import MarkdownUI

struct MarkdownView: View {
    let markdown: String
    let baseURL: URL?

    @State private var search = SearchModel()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Markdown(markdown,
                         baseURL: baseURL,
                         imageBaseURL: baseURL)
                .markdownImageProvider(LocalFileImageProvider())
                
                .markdownBlockStyle(\.paragraph) { configuration in
                    let text = configuration.content.renderPlainText()
                    let highlighted = isSearchMatch(text)

                    let blockID = "paragraph-\(text.hashValue)"

                    configuration.label
                        .id(blockID)
                        .fixedSize(horizontal: false, vertical: true)
                        .relativeLineSpacing(.em(0.25))
                        .padding(.horizontal, highlighted ? 4 : 0)
                        .background {
                            if highlighted {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.accentColor.opacity(0.16))
                            }
                        }
                        .preference(
                            key: SearchMatchPreferenceKey.self,
                            value: highlighted ? [blockID] : []
                        )
                        .markdownMargin(top: 0, bottom: 16)
                }
                
                .markdownBlockStyle(\.codeBlock) { configuration in
                    let highlighted = isSearchMatch(configuration.content)

                    let blockID = "code-\(configuration.content.hashValue)"

                    ScrollView(.horizontal) {
                        configuration.label
                            .padding(14)
                    }
                    .id(blockID)
                    .markdownTextStyle {
                        FontFamilyVariant(.monospaced)
                        FontSize(.em(0.9))
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                highlighted
                                    ? Color.accentColor.opacity(0.14)
                                    : Color.secondary.opacity(0.08)
                            )
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                highlighted
                                    ? Color.accentColor.opacity(0.55)
                                    : Color.secondary.opacity(0.15),
                                lineWidth: highlighted ? 2 : 1
                            )
                    }
                    .preference(
                        key: SearchMatchPreferenceKey.self,
                        value: highlighted ? [blockID] : []
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                    .markdownMargin(top: 8, bottom: 16)
                }
                .textSelection(.enabled)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(32)
                .markdownBlockStyle(\.paragraph) { configuration in
                    let highlighted = isSearchMatch(
                        configuration.content.renderPlainText()
                    )

                    configuration.label
                        .fixedSize(horizontal: false, vertical: true)
                        .relativeLineSpacing(.em(0.25))
                        .padding(.horizontal, highlighted ? 4 : 0)
                        .background {
                            if highlighted {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        Color.accentColor.opacity(0.16)
                                    )
                            }
                        }
                        .markdownMargin(top: 0, bottom: 16)
                }
                .onPreferenceChange(SearchMatchPreferenceKey.self) { blockIDs in
                    guard
                        search.isPresented,
                        !search.query.isEmpty,
                        let firstBlockID = blockIDs.first
                    else {
                        return
                    }

                    withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo(
                            firstBlockID,
                            anchor: .center
                        )
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                if search.isPresented {
                    FindBar(
                        search: search,
                        document: markdown
                    )
                }
            }
            .focusedSceneValue(
                \.crimsonSearchActions,
                 CrimsonSearchActions(
                    show: {
                        search.show()
                    },
                    next: {
                        search.next()
                    },
                    previous: {
                        search.previous()
                    }
                 )
            )
        }
    }
    
    private func isSearchMatch(_ text: String) -> Bool {
        guard search.isPresented else {
            return false
        }

        let query = search.query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return false
        }

        return text.range(
            of: query,
            options: [
                .caseInsensitive,
                .diacriticInsensitive
            ]
        ) != nil
    }
}

private struct SearchMatchPreferenceKey: PreferenceKey {
    static var defaultValue: [String] = []

    static func reduce(
        value: inout [String],
        nextValue: () -> [String]
    ) {
        value.append(contentsOf: nextValue())
    }
}
