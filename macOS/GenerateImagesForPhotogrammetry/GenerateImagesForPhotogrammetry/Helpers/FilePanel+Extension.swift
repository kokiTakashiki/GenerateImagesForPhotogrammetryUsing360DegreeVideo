//
//  FilePanel+Extension.swift
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

extension NSSavePanel {
    static func saveImage(_ image: NSImage) async throws {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.nameFieldStringValue = "image.jpg"
        savePanel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        let result = await savePanel.begin()
        guard result == .OK,
            let url = savePanel.url
        else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get file location"])
        }
        
        Task.detached {
            guard
                let data = image.tiffRepresentation,
                let imageRep = NSBitmapImageRep(data: data) else { return }
            
            do {
                let imageData = imageRep.representation(using: .jpeg, properties: [.compressionFactor: 1.0])
                try imageData?.write(to: url)
            } catch {
                throw error
            }
        }
    }
}


