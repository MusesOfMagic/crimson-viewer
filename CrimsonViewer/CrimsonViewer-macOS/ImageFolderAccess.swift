//
//  ImageFolderAccess..swift
//  Crimson Viewer
//
//  Created by Muses of Magic on 27/11/2026.
//

import Foundation

final class ImageFolderAccess {
    let id = UUID()
    let url: URL

    init?(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            return nil
        }

        self.url = url
    }

    deinit {
        url.stopAccessingSecurityScopedResource()
    }
}
