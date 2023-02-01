//
//  InfiniteHorizontalList.swift
//  GenerateImagesForPhotogrammetry
//
//  Created by 武田孝騎 on 2023/01/28.
//

import SwiftUI

struct InfiniteHorizontalList<Data, Content>: View
where Data : RandomAccessCollection, Data.Element : Hashable, Content : View  {
    @Binding var data: Data
    @Binding var isLoading: Bool
    let loadMore: () -> Void
    let content: (Data.Element) -> Content
    
    init(data: Binding<Data>,
         isLoading: Binding<Bool>,
         loadMore: @escaping () -> Void,
         @ViewBuilder content: @escaping (Data.Element) -> Content) {
        _data = data
        _isLoading = isLoading
        self.loadMore = loadMore
        self.content = content
    }
    
    // TODO: 自動ロードMORE
    var body: some View {
        HStack {
            ForEach(data, id: \.self) { item in
                content(item)
//                    .onAppear {
//                        if item == data.last {
//                            loadMore()
//                        }
//                    }
            }
            Button(action: {
                loadMore()
            }, label: {
                Text("Load")
            })
//            if isLoading {
//                ProgressView()
//            }
        }
//        .onAppear(perform: loadMore)
    }
}
