//
//  FindBar.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 29/09/2026.
//

import SwiftUI

struct FindBar: View {
    @Bindable var search: SearchModel

    let document: String

    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            TextField("Find", text: $search.query)
                .textFieldStyle(.roundedBorder)
                .frame(width: 220)
                .focused($searchFieldFocused)
                .onSubmit {
                    search.next()
                }

            Text(search.resultText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(minWidth: 60)

            Button {
                search.previous()
            } label: {
                Image(systemName: "chevron.up")
            }
            .buttonStyle(.borderless)
            .disabled(search.matchCount == 0)
            .help("Previous Match")

            Button {
                search.next()
            } label: {
                Image(systemName: "chevron.down")
            }
            .buttonStyle(.borderless)
            .disabled(search.matchCount == 0)
            .help("Next Match")

            Button {
                search.close()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
            .help("Close")
        }
        .padding(8)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 9))
        .shadow(radius: 5, y: 2)
        .padding(12)
        .onAppear {
            searchFieldFocused = true
            search.search(in: document)
        }
        .onChange(of: search.query) {
            search.search(in: document)
        }
        .onExitCommand {
            search.close()
        }
    }
}
