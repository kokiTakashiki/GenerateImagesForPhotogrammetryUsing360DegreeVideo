//
//  ExtractFrameView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI
import AVKit

struct ExtractFrameView: View {

    @EnvironmentObject var appState: AppState
    let playerItemObserver: PlayerItemObserver
    @State private var isExtractFrameButton = false
    @State private var resultImages: [NSImage?] = []
    @State private var input = ""

    var body: some View {
        VStack {
            if isExtractFrameButton {
                HStack {
                    TextField("フレーム数 (default 1frames per second.)", text: $input)
                        .frame(width: 300)
                    Button(action: {
                        Task.detached {
                            let images = await appState.imagesFromVideo(frameNumber: CMTimeScale(Int(input) ?? 1))
                            Task { @MainActor in
                                self.resultImages = images
                            }
                        }
                    }, label: {
                        Text("Start Extract")
                    })
                }
            }
            ZStack {
                if resultImages.isEmpty {
                    Text("no result")
                        .frame(width: 160, height: 160)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                } else {
                    VStack {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(resultImages, id: \.self) { image in
                                    if image != nil {
                                        Image(nsImage: image!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 160, height: 160)
                                            .background(Color.black.opacity(0.5))
                                            .cornerRadius(8)
                                    } else {
                                        Text("no result")
                                    }
                                }
                            }
                        }
                        Text("result: \(resultImages.count) images")
                    }
                }
            }
            .padding(.trailing, 16.0)
            .padding(.leading, 16.0)
        }
        .onReceive(playerItemObserver.$currentStatus) { newStatus in
            switch newStatus {
            case .unknown:
                isExtractFrameButton = false
            case .failed:
                isExtractFrameButton = false
            case .readyToPlay:
                isExtractFrameButton = true
            case .none:
                isExtractFrameButton = false
            case .some(_):
                isExtractFrameButton = false
            }
        }
    }
}
