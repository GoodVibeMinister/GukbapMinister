//
//  StoreImagesTabView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import SwiftUI

import Kingfisher
import FirebaseStorage

struct StoreImagesTabView: View {
    
    @StateObject var manager = StoreImageManager(store: .test)
    @Binding var showDetail: Bool
    
    var body: some View {
        TabView {
            ForEach(manager.imageURLs, id: \.self){ url in
                Button(action: {
                    showDetail.toggle()
                }){
                    KFImage(url)
                        .placeholder {
                            Gukbaps(rawValue: manager.store.foodType.first ?? "순대국밥")?.placeholder
                                .resizable()
                                .scaledToFill()
                        }
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .frame(height:Screen.maxWidth * 0.8)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
    
    
    
}



