//
//  ProgressBar.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/20.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray.opacity(0.5))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(.gray))
                    .animation(Animation.linear(duration: 0.0), value: value)
            }.cornerRadius(45.0)
        }
    }
}
