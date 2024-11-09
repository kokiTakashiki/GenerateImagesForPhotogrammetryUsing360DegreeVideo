//
//  InputVideoDragAndDropView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI
import AVKit

struct InputVideoDragAndDropView: View {
    
    @EnvironmentObject var appState: AppState
    @Binding var videoUrl: URL?
    
    var body: some View {
        ZStack {
            if videoUrl != nil {
                VideoPlayer(player: appState.player)
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
                if let urlData = urlData as? Data {
                    Task { @MainActor in
                        self.videoUrl = URL(dataRepresentation: urlData, relativeTo: nil)
                    }
                }
            }
            return true
        }
        return false
    }
}

struct InputVideoDragAndDropView_Previews: PreviewProvider {
    @State static var videoUrl: URL? = nil //NSImage()
    static var previews: some View {
        InputVideoDragAndDropView(videoUrl: $videoUrl)
    }
}
