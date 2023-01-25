//
//  AppState.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import Combine
import Cocoa
import AVKit

final class AppState: ObservableObject {

    static let shared = AppState()

    private var cancels = Set<AnyCancellable>()

    @Published var image: NSImage?
    @Published var videoUrl: URL?

    @Published var player: AVPlayer = AVPlayer()
    @Published var playerItem: AVPlayerItem?

    @Published var progressValue: Float = 0.0

    private init() {
        $videoUrl.sink { [weak self] urlNil in
            guard let url = urlNil else { return }
            self?.open(url)
        }
        .store(in: &cancels)
    }
    
    private func open(_ url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.playerItem = playerItem
        player.replaceCurrentItem(with: playerItem)
    }
}

// MARK: ExtractFrame
extension AppState {
    func imageFromVideo(url: URL, at time: TimeInterval) -> NSImage? {
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

    func imagesFromVideo(frameNumber: CMTimeScale) -> [NSImage?] {
        var result: [NSImage?] = []
        guard let playerItem = playerItem else {
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
            Task { @MainActor in
                progressValue += 0.1
            }
        }

        return result
    }
}

final class PlayerItemObserver {
    
    @Published var currentStatus: AVPlayerItem.Status?
    private var itemObservation: AnyCancellable?

    init(playerItem: AVPlayerItem) {

        itemObservation = playerItem.publisher(for: \.status).sink { newStatus in
            self.currentStatus = newStatus
        }

    }

}
