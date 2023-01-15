//
//  InputVideoDragAndDropView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI
import AVKit

struct InputVideoDragAndDropView: View {
    
    @Binding var videoUrl: NSURL?
    
    var body: some View {
        ZStack {
            if videoUrl != nil {
                VideoPlayer(player: AVPlayer(url: (videoUrl!) as URL))
                    .frame(height: 320)
            } else {
                Text("Drag and drop video file")
                    .frame(width: 320)
            }
        }
        .frame(height: 320)
        .background(Color.black.opacity(0.5))
        .cornerRadius(8)
        .padding(.trailing, 16.0)
        .padding(.leading, 16.0)
            
        .onDrop(of: ["public.file-url"], isTargeted: nil, perform: handleOnDrop(providers:))
    }
    
    private func handleOnDrop(providers: [NSItemProvider]) -> Bool {
        if let item = providers.first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data {
                        self.videoUrl = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil)
                    }
                }
            }
            return true
        }
        return false
    }
}

struct InputVideoDragAndDropView_Previews: PreviewProvider {
    @State static var videoUrl: NSURL? = nil //NSImage()
    static var previews: some View {
        InputVideoDragAndDropView(videoUrl: $videoUrl)
    }
}
