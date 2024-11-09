//
//  InputImageDragAndDropView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI

struct InputImageDragAndDropView: View {
    
    @Binding var image: NSImage?
        
    var body: some View {
        ZStack {
            if image != nil {
                Image(nsImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Drag and drop image file")
                    .frame(width: 320)
            }
        }
        .frame(height: 320)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
            
        .onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
    }
        
    private func handleOnDrop(providers: [NSItemProvider]) -> Bool {
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                if let urlData = urlData as? Data {
                    let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                    guard let image = NSImage(contentsOf: url) else {
                        return
                    }
                    Task { @MainActor in
                        self.image = image
                    }
                }
            }
            return true
        }
        return false
    }
}

struct InputImageView_Previews: PreviewProvider {
    @State static var image: NSImage? = nil //NSImage()
    static var previews: some View {
        InputImageDragAndDropView(image: $image)
    }
}
