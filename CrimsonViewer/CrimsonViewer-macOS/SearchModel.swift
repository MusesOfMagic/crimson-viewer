//
//  SearchModel.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 29/09/2026.
//

import SwiftUI

@Observable
@MainActor
final class SearchModel {
    var query = ""
    var isPresented = false
    var currentIndex = 0

    private(set) var ranges: [Range<String.Index>] = []

    var matchCount: Int {
        ranges.count
    }

    var currentRange: Range<String.Index>? {
        guard ranges.indices.contains(currentIndex) else {
            return nil
        }

        return ranges[currentIndex]
    }

    var resultText: String {
        guard !query.isEmpty else {
            return ""
        }

        guard !ranges.isEmpty else {
            return "No matches"
        }

        return "\(currentIndex + 1) of \(ranges.count)"
    }

    func search(in text: String) {
        ranges.removeAll()
        currentIndex = 0

        guard !query.isEmpty else {
            return
        }

        var searchRange = text.startIndex..<text.endIndex

        while let range = text.range(
            of: query,
            options: [.caseInsensitive, .diacriticInsensitive],
            range: searchRange
        ) {
            ranges.append(range)
            searchRange = range.upperBound..<text.endIndex
        }
    }

    func next() {
        guard !ranges.isEmpty else {
            return
        }

        currentIndex = (currentIndex + 1) % ranges.count
    }

    func previous() {
        guard !ranges.isEmpty else {
            return
        }

        currentIndex =
            (currentIndex - 1 + ranges.count) % ranges.count
    }

    func show() {
        isPresented = true
    }

    func close() {
        isPresented = false
    }
}
