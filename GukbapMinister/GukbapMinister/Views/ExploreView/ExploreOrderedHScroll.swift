//
//  ExploreOrderedHscroll.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import SwiftUI

enum ExploreOrderingMode {
    case star,hits
}
struct ExploreOrderedHScroll: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var storesViewModel: StoresViewModel
    @ObservedObject var exploreViewModel: ExploreViewModel
    
    var mode: ExploreOrderingMode
    var stores: [Store] {
        return mode == .hits ? exploreViewModel.storesOrderedByHits : exploreViewModel.storesOrderedByStar
    }
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0){
                
                Text(mode == .hits ? "국밥집 조회수 랭킹" : "깍두기 점수가 높은 국밥집")
                    .font(.body)
                    .bold()
                Spacer()
                
                NavigationLink{
                  ExploreOrderedList(exploreViewModel: exploreViewModel, mode: mode)
                        .environmentObject(storesViewModel)
                } label:{
                    Text("더보기 >")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
                
            }
            .padding(.top)
            .padding(.leading)
            .font(.body)
            
            
            Text(mode == .hits ?
                 "사람들이 가장 많이 찾아본 국밥집들을 소개합니다" : "사람들이 높게 평가한 국밥집을 모아봤어요"
            )
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.leading)
                .padding(.top, 3)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, alignment: .center) {
                    ForEach(stores, id: \.self){ store in
                        NavigationLink{
                           DetailView(detailViewModel: DetailViewModel(store: store))
                        } label:{
                           ExploreOrderedHScrollCell(exploreViewModel: exploreViewModel, store: store, mode: mode)
                                .environmentObject(storesViewModel)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            if mode == .hits {
                                exploreViewModel.increaseHits(store: store)
                            }
                        })
                        .padding(.bottom, 10)
                    }
                }
                .padding(.leading, 10)
            }
        }
        .background(scheme == .light ? .white : .black)
    }
}

