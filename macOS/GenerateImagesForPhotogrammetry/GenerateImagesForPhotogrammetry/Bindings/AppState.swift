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

final class PlayerItemObserver {
    
    @Published var currentStatus: AVPlayerItem.Status?
    private var itemObservation: AnyCancellable?

    init(playerItem: AVPlayerItem) {

        itemObservation = playerItem.publisher(for: \.status).sink { newStatus in
            self.currentStatus = newStatus
        }

    }

}
