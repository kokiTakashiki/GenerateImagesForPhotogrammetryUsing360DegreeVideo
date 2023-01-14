//
//  InputVideoView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/15.
//

import SwiftUI
import AVKit

struct InputVideoView: View {
    
    @Binding var videoUrl: NSURL?
    
    var body: some View {
        InputVideoDragAndDropView(videoUrl: $videoUrl)
    }
}

struct InputVideoView_Previews: PreviewProvider {
    @State static var videoUrl: NSURL? = nil
    static var previews: some View {
        InputVideoView(videoUrl: $videoUrl)
    }
}
