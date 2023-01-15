//
//  InputImageView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI

struct InputImageView: View {
    
    @Binding var image: NSImage?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Input image")
                    .font(.headline)
                Button(action: {
                    Task {
                        self.image = await selectFile()
                    }
                }, label: {
                    Text("Select image")
                })
            }
            InputImageDragAndDropView(image: self.$image)
            if image != nil {
                Button(action: {
                    Task {
                        await saveToFile()
                    }
                }, label: {
                    Text("Save image")
                })
            }
        }
    }
    
    private func selectFile() async -> NSImage? {
        do {
            return try await NSOpenPanel.openImage()
        } catch {
            return nil
        }
    }
    
    private func saveToFile() async {
        guard let image = image else {
            return
        }
        do {
            try await NSSavePanel.saveImage(image)
        } catch {}
    }
}

struct InputView_Previews: PreviewProvider {
    @State static var image: NSImage? = NSImage()
    static var previews: some View {
        InputImageView(image: $image)
    }
}
