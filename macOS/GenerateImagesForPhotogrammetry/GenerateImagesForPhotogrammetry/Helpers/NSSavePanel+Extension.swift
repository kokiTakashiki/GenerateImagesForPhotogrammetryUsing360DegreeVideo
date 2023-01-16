//
//  NSSavePanel+Extension.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import Cocoa

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
