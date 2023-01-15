//
//  AppState.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import Combine
import Cocoa

class AppState: ObservableObject {
    
    static let shared = AppState()
    
    private init() {}

    @Published var image: NSImage?
    @Published var videoUrl: URL?
}

