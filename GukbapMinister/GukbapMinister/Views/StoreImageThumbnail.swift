//
//  StoreImageThumbnail.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/04.
//

import SwiftUI

import Kingfisher
import FirebaseStorage

enum ImageThumbnailMode {
    case random, first, multiple, tab
}

///이미지 썸네일
struct StoreImageThumbnail: View {

    var store: Store
    var size: CGFloat
    var cornerRadius: CGFloat
    var mode: ImageThumbnailMode = .random
    
    
    var body: some View {
        VStack {
            if !store.storeImages.isEmpty {
                switch mode {
                case .random: random // 랜덤으로 이미지를 보여줌
                case .first: first // 첫번째 url 이미지를 보여줌(랜덤이 될 가능성이 있음)
                case .multiple: multiple // 여러장의 이미지를 보여줌
                case .tab: tab //여러장의 이미지를 탭뷰로 보여줌(순서는 생성될때마다 랜덤)
                }
            } else {
                Gukbaps(rawValue: store.foodType.first ?? "순대국밥")?.placeholder
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: size)
                    .cornerRadius(cornerRadius)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.black.opacity(0.2))
        }

    }
    
    private var random: some View {
      
            VStack {
                ZStack(alignment: .bottomTrailing){
                 
                
                if let urlString = store.storeImages.shuffled().first {
                    getImage(urlString)
                    Text("\(store.storeImages.count)")
                        .foregroundColor(.white)
                        .font(.callout)
                        .fontWeight(.regular)
                        .frame(width: size / 4.5, height: size / 4.5)
                        .background(Rectangle().fill(Color.black).opacity(0.35).shadow(radius: 3))
                        .cornerRadius(cornerRadius)
                        
                }
                }
            }
        
       
    }
    private var first: some View {
        VStack {
            if let urlString = store.storeImages.first {
                getImage(urlString)
            }
        }
    }
    private var multiple: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(store.storeImages, id: \.self) { urlString in
                    getImage(urlString)
                }
            }
        }
    }
    
    private var tab: some View {
        TabView {
            ForEach(store.storeImages, id: \.self) { urlString in
                VStack {
                    getImage(urlString)
                        .overlay {
                            LinearGradient(colors: [.black.opacity(0.2), .clear], startPoint: UnitPoint(x: 0.5, y: 1), endPoint: UnitPoint(x: 0.5, y: 0))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(width: size, height: size)
    }
    
    @ViewBuilder
    private func getImage(_ urlString: String) -> some View {
        KFImage.url(URL(string: urlString))
            .resizable()
            .placeholder {
                if let gukbap = store.foodType.first {
                    Gukbaps(rawValue: gukbap)?.placeholder
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: size)
                        .cornerRadius(cornerRadius)
                }
            }
            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: size * 2.0, height: size * 2.0)))//이미지 사이즈의 1.8배정도로 다운샘플링 -> 너무 흐려서 2.0으로 수정함
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 1)
            .cancelOnDisappear(true)
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .cornerRadius(cornerRadius)
    }
    
}


