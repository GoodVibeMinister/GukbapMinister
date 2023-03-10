//
//  StoreImageThumbnail.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/04.
//

import SwiftUI
import Kingfisher

enum ImageThumbnailMode {
    case random, first, multiple, tab
}

///이미지 썸네일
struct StoreImageThumbnail: View {
    @StateObject var manager = StoreImageManager(store: .test)
    @State private var tabSelection: Int = 0
    
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var mode: ImageThumbnailMode = .random
    
    var body: some View {
        VStack {
            if !manager.imageURLs.isEmpty {
                switch mode {
                case .random: random // 랜덤으로 이미지를 보여줌
                case .first: first // 첫번째 url 이미지를 보여줌(랜덤이 될 가능성이 있음)
                case .multiple: multiple // 여러장의 이미지를 보여줌
                case .tab: tab //여러장의 이미지를 탭뷰로 보여줌(순서는 생성될때마다 랜덤)
                }
            } else {
                Gukbaps(rawValue: manager.store.foodType.first ?? "순대국밥")?.placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(.black.opacity(0.2))
        }
    }
    
    var random: some View {
        VStack {
            if let url = manager.imageURLs.shuffled().first {
                getImage(url)
            }
        }
    }
    var first: some View {
        VStack {
            if let url = manager.imageURLs.first {
                getImage(url)
            }
        }
    }
    var multiple: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(manager.imageURLs, id: \.self) { url in
                    getImage(url)
                }
            }
        }
    }
    
    var tab: some View {
        TabView {
            ForEach(manager.imageURLs, id: \.self) { url in
                VStack {
                    getImage(url)
                        .overlay {
                            LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: UnitPoint(x: 0.5, y: 1), endPoint: UnitPoint(x: 0.5, y: 0))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(width: width, height: height)
    }
    
    @ViewBuilder
    func getImage(_ url: URL) -> some View {
        KFImage(url)
            .placeholder {
                if let gukbap = manager.store.foodType.first {
                    Gukbaps(rawValue: gukbap)?.placeholder
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .cornerRadius(cornerRadius)
                }
            }
            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: width * 2, height: height * 2)))//이미지 사이즈의 2배정도로 다운샘플링
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.5)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
    }
}


