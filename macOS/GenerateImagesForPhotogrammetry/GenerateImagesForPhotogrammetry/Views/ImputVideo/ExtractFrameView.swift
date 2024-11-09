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
    @StateObject var state = ExtractFrameState.shared
    let playerItemObserver: PlayerItemObserver
    @State private var isExtractFrameButton = false
    @State private var input = ""

    var body: some View {
        VStack {
            if isExtractFrameButton {
                HStack {
                    TextField("フレーム数 (default 1frames per second.)", text: $input)
                        .frame(width: 300)
                    Button(action: {
                        appState.progressValue = 0.0
                        state.isLoading = false
                        state.resultImagesDisplay = []
                        Task { @MainActor in
                            let images = await appState.imagesFromVideo(frameNumber: CMTimeScale(Int(input) ?? 1))
                            self.state.resultImages = images
                        }
                    }, label: {
                        Text("Start Extract")
                    })
                }
            }
            VStack {
                if state.resultImages.isEmpty {
                    Text("no result")
                        .frame(width: 160, height: 160)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                } else {
                    VStack {
                        ScrollView(.horizontal) {
                            resultList()
                        }
                        HStack {
                            Text("result: \(state.resultImages.count) images")
                            Spacer()
                        }
                    }
                }
                HStack {
                    Spacer()
                    if appState.progressValue == 1.0 {
                        Text("Complete")
                    } else {
                        ProgressBar(value: $appState.progressValue)
                            .frame(width: 300, height: 10)
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

extension ExtractFrameView {
    private func resultList() -> some View {
        InfiniteHorizontalList(
            data: $state.resultImagesDisplay,
            isLoading: $state.isLoading,
            loadMore: state.loadMore) { item in
                resultListCell(item)
            }
    }

    @ViewBuilder
    private func resultListCell(_ image: NSImage?) -> some View {
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
