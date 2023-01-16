//
//  NSOpenPanel+Extension.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import Cocoa

extension NSOpenPanel {
    static func openImage() async throws -> NSImage {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.jpeg, .png, .heic]//["jpg", "jpeg", "png", "heic"]
        panel.canChooseFiles = true
        let result = await panel.begin()
        guard
            result == .OK,
            let url = panel.urls.first,
            let image = NSImage(contentsOf: url)
        else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
        }
        return image
    }
}

extension NSOpenPanel {
    static func openVideo() async throws -> URL {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.mpeg4Movie]
        panel.canChooseFiles = true
        let result = await panel.begin()
        guard
            result == .OK,
            let url = panel.urls.first
        else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
        }
        return url
    }
}
