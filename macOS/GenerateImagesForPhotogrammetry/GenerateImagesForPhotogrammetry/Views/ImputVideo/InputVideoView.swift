//
//  InputVideoView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI

struct InputVideoView: View {
    
    @EnvironmentObject var appState: AppState
    @Binding var videoUrl: URL?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Input video")
                    .font(.headline)
                Button(action: {
                    Task {
                        self.videoUrl = await selectFile()
                    }
                }, label: {
                    Text("Select video")
                })
            }
            InputVideoDragAndDropView(videoUrl: $videoUrl)
                .environmentObject(appState)
        }
    }
}

extension InputVideoView {
    private func selectFile() async -> URL? {
        do {
            return try await NSOpenPanel.openVideo()
        } catch {
            return nil
        }
    }
}

struct InputVideoView_Previews: PreviewProvider {
    @State static var videoUrl: URL? = nil
    static var previews: some View {
        InputVideoView(videoUrl: $videoUrl)
    }
}
