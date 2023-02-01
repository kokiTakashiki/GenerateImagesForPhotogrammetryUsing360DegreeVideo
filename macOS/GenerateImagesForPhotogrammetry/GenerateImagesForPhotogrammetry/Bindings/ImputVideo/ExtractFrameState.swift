//
//  ExtractFrameState.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/28.
//

import SwiftUI
import Combine

final class ExtractFrameState: ObservableObject {
    static let shared = ExtractFrameState()
    
    @Published var resultImages: [NSImage?] = []
    @Published var resultImagesDisplay: [NSImage?] = []
    @Published var isLoading = false
    
    private var page = 0
    private var maxPage = 0
    private var cancels = Set<AnyCancellable>()
    
    private init() {}
    
    func loadMore() {
        guard !isLoading else { return }
        isLoading = true

        maxPage = (resultImages.count / 10)
        
        (0..<10).publisher
            .map { index in
                if let image: NSImage = resultImages[safe: index+(page*10)] as? NSImage {
                    return image
                } else {
                    return nil
                }
            }
            .collect()
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if self.page != self.maxPage {
                    self.isLoading = false
                    self.page += 1
                }
            } receiveValue: { [self] value in
                resultImagesDisplay += value
            }
            .store(in: &cancels)
    }
}
