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
                Button(action: selectFile) {
                    Text("Select image")
                }
            }
            InputImageDragAndDropView(image: self.$image)
            if image != nil {
                Button(action: saveToFile) {
                    Text("Save image")
                }
            }
        }
    }
    
    private func selectFile() {
        NSOpenPanel.openImage { (result) in
            if case let .success(image) = result {
                self.image = image
            }
        }
    }
    
    private func saveToFile() {
        guard let image = image else {
            return
        }
        NSSavePanel.saveImage(image, completion: { _ in  })
    }
}

struct InputView_Previews: PreviewProvider {
    @State static var image: NSImage? = NSImage()
    static var previews: some View {
        InputImageView(image: $image)
    }
}
