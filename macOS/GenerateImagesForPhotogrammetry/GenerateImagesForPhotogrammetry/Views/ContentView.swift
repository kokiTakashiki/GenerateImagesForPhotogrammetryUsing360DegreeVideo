//
//  ContentView.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/14.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var appState = AppState.shared
    let pickerValues = ["video", "image"]
    @State private var selection = "image"

    var body: some View {
        VStack(spacing: 16) {
            Picker("Segmented Picker", selection: $selection) {
                pickerContent()
            }
            .pickerStyle(.segmented)
            .padding(.trailing, 16)
            .padding(.leading, 16)
            switch selection {
            case "video":
                Text("video")
                InputVideoView(videoUrl: self.$appState.videoUrl)
            case "image":
                InputImageView(image: self.$appState.image)
                Divider()
    //            CarouselFilterView(image: appState.image, filteredImage: self.$appState.filteredImage)
    //            .equatable()
                Text("result")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
            default:
                EmptyView()
            }
            
            Spacer()
        }
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(minWidth: 768, idealWidth: 768, maxWidth: 1024, minHeight: 648, maxHeight: 648)
    }

    @ViewBuilder
    private func pickerContent() -> some View {
        ForEach(pickerValues, id: \.self) {
            Text($0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}