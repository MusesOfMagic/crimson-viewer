//
//  FolderAccessManager.swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 27/11/2026.
//

import Foundation

@MainActor
enum FolderAccessManager {

    private static let storageKey = "AuthorisedFolderBookmarks"

    private static var bookmarks: [String: Data] {
        get {
            UserDefaults.standard.dictionary(
                forKey: storageKey
            ) as? [String: Data] ?? [:]
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: storageKey
            )
        }
    }

    static func remember(_ access: ImageFolderAccess) throws {
        let url = access.url

        let bookmark = try url.bookmarkData(
            options: .minimalBookmark,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        var savedBookmarks = bookmarks

        savedBookmarks[url.standardizedFileURL.path] = bookmark

        bookmarks = savedBookmarks

        print("[FolderAccess] Saved: \(url.path)")
    }

    static func restore(
        for directory: URL
    ) -> ImageFolderAccess? {

        let candidates = bookmarks
            .filter { entry in
                contains(
                    URL(fileURLWithPath: entry.key,
                        isDirectory: true),
                    directory: directory
                )
            }
            .sorted { $0.key.count > $1.key.count }

        for (path, bookmark) in candidates {
            do {
                var isStale = false

                let url = try URL(
                    resolvingBookmarkData: bookmark,
                    options: [],
                    relativeTo: nil,
                    bookmarkDataIsStale: &isStale
                )

                guard contains(url, directory: directory),
                      let access = ImageFolderAccess(url: url)
                else {
                    continue
                }

                if isStale {
                    do {
                        try remember(access)
                    } catch {
                        print("[FolderAccess] Refresh failed: \(error)")
                    }
                }

                print("[FolderAccess] Restored: \(url.path)")

                return access

            } catch {
                print("[FolderAccess] Restore failed for \(path): \(error)")
            }
        }

        return nil
    }

    private static func contains(
        _ folder: URL,
        directory: URL
    ) -> Bool {
        directory.standardizedFileURL.pathComponents
            .starts(
                with: folder.standardizedFileURL.pathComponents
            )
    }
}
