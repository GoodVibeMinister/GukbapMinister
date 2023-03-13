//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI
import Kingfisher

struct StoreModalView: View {
    // 다크 모드 지원
    @Environment(\.colorScheme) var scheme
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()

    var store: Store?
    var checkAllReviewCount : [Review] {
        reviewViewModel.reviews.filter{
            $0.storeName == store?.storeName
        }
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack{
                    storeTitle

                }
                divider
                    
                HStack {
                    if let store {
                        NavigationLink {
                            DetailView(detailViewModel: DetailViewModel(store: store))
                        } label: {
                            StoreImageThumbnail(store: store, size: 90, cornerRadius: 6)
                        }
                    }
                    VStack(alignment: .leading){
                        Menu {
                            Button {
                                let pasteboard = UIPasteboard.general
                                pasteboard.string = store?.storeAddress
                            } label: {
                                Label("이 주소 복사하기", systemImage: "doc.on.clipboard")
                            }
                            Text(store?.storeAddress ?? "")
                                .lineLimit(1)
                                .font(.subheadline)

                        } label: {
                            HStack {
                                Text(store?.storeAddress ?? "")
                                    // 다크 모드 지원
                                    .foregroundColor(scheme == .dark ? .white : .secondary)
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                Image(systemName: "doc.on.doc")
                                
                                Spacer()
                            }
                            .font(.subheadline)
                        }
                        .frame(height:Screen.maxHeight * 0.02)
                        
                        HStack{
                            Text("방문자리뷰")
                                .foregroundColor(scheme == .dark ? .white : .secondary)
                            Text("\(checkAllReviewCount.count)")
                                .foregroundColor(Color("AccentColor"))
                            Spacer()

                        }
                        .font(.subheadline)

                        HStack{
                            GgakdugiRatingShort(rate: store?.countingStar ?? 0.0, size: 20)
                            Text("/ 5")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.leading,-5)
                        }
                    }

                }
                .frame(height: Screen.maxHeight * 0.0985)
                .padding(.leading)
            }
        }
        .frame(width: Screen.searchBarWidth, height: 160)
        .background(RoundedRectangle(cornerRadius: 10).fill(scheme == .dark ? .black : Color.white))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.mainColor.opacity(0.5))
        }
        .onAppear {
            print("모달이 나오겠습니다")
            reviewViewModel.fetchAllReviews()
        }
    }
    
}

extension StoreModalView {
    var storeTitle: some View {
        
            NavigationLink(destination: DetailView(detailViewModel: DetailViewModel(store: store ?? .test))) {
                Text(store?.storeName ?? "")
                    .foregroundColor(scheme == .dark ? .white : .accentColor)                
                    .font(.title3)
                    .fontWeight(.medium)
            }
           
        
        .padding(.leading)
    }
    
    var divider: some View {
        Divider()
            .frame(width: Screen.searchBarWidth, height: 1)
            .overlay(Color.mainColor.opacity(0.5))
    }
    
    var reviewCount: some View {
        HStack{
            
        }
    }
}


