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
                            let images = await imagesFromVideo(frameNumber: CMTimeScale(Int(input) ?? 1))
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
                if !resultImages.isEmpty {
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
                } else {
                    Text("no result")
                        .frame(width: 160, height: 160)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
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

extension ExtractFrameView {
    private func imageFromVideo(url: URL, at time: TimeInterval) -> NSImage? {
        let asset = AVURLAsset(url: url)

        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }

        return NSImage(cgImage: thumbnailImageRef, size: NSSize(width: 300, height: 300))
    }

    private func imagesFromVideo(frameNumber: CMTimeScale) -> [NSImage?] {
        var result: [NSImage?] = []
        guard let playerItem = appState.playerItem else {
            return []
        }

        // 総再生時間(秒) x １秒間のフレーム数
        let durationFrame = CMTimeGetSeconds(playerItem.duration) * Double(frameNumber)
        let imagesCount: Int = Int(durationFrame)

        let asset = playerItem.asset
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        for i in 0 ..< imagesCount {
            let cmTime = CMTime(seconds: Double(i), preferredTimescale: frameNumber)
            do {
                let thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
                result.append(
                    NSImage(cgImage: thumbnailImageRef, size: NSSize(width: 300, height: 300))
                )
            } catch let error {
                print("Error: \(error)")
                result.append(nil)
            }
        }

        return result
    }
}
