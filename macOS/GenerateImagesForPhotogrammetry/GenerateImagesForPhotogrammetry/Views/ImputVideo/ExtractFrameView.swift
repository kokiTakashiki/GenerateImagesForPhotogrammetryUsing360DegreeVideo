//
//  ExtractFrameView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI
import AVKit

struct ExtractFrameView: View {

    @Binding var videoUrl: URL?
    @State var resultImage: NSImage?

    var body: some View {
        VStack {
            Button(action: {
                Task.detached {
                    if videoUrl != nil {
                        let image = imageFromVideo(url: videoUrl!, at: 0)
                        Task { @MainActor in
                            self.resultImage = image
                        }
                    }
                }
            }, label: {
                Text("Start Extract")
            })
            ZStack {
                if resultImage != nil {
                    Image(nsImage: resultImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Text("no result")
                }
            }
            .frame(width: 160, height: 160)
            .background(Color.black.opacity(0.5))
            .cornerRadius(8)
            .padding(.trailing, 16.0)
            .padding(.leading, 16.0)
        }
    }
}

extension ExtractFrameView {
    private func imageFromVideo(url: URL, at time: TimeInterval) -> NSImage? {
        let asset = AVURLAsset(url: url)

        var metadataString = ""
        dump(asset.commonMetadata, to: &metadataString)
        print("\(metadataString)")
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
}

struct ExtractFrameView_Previews: PreviewProvider {
    @State static var videoUrl: URL? = nil
    static var previews: some View {
        ExtractFrameView(videoUrl: $videoUrl)
    }
}
