//
//  ExploreHScrollCell.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import SwiftUI
import Kingfisher

struct ExploreOrderedHScrollCell: View {
    @Environment(\.colorScheme) var scheme
    @ObservedObject var exploreViewModel: ExploreViewModel
    var store : Store
    var mode: ExploreOrderingMode

    var body: some View{
        VStack{
            VStack{
                ZStack(alignment: .topLeading){
                    HStack(alignment: .center, spacing: 0){
                        switch mode {
                        case .hits:
                            Image(systemName: "eye")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 15, height: 10)
                                .padding(.trailing, 5)
                            
                            
                            Text("\(store.hits)")
                                .font(.caption)
                                .bold()
                        case .star:
                            Image("Ggakdugi")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .padding(.trailing, 5)
                            
                            
                            Text("\(String(format: "%.1f", store.countingStar))")
                                .font(.caption)
                                .bold()
                        }
                    }
                    .zIndex(1)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.5)))
                    .padding(.top, 3)
                    .padding(.leading, 3)

                    StoreImageThumbnail(manager: StoreImageManager(store: store), width: 190, height: 190, cornerRadius: 10, mode: .tab)
                }
                
                
                VStack(alignment: .leading, spacing: 1){
                    HStack {
                        Text("\(store.storeName)")
                            .fontWeight(.bold)
                            .font(.callout)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(scheme == .light ? Color("AccentColor").opacity(0.1) : Color("AccentColor").opacity(0.5)))
                            .foregroundColor(scheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("\(store.storeAddress)")
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.leading, 3)
                            .foregroundColor(scheme == .light ? .black : .white)
                        Spacer()
                    }
                    .padding(.vertical, 3)
                    
                    
                    HStack {
                        Text("\(store.description)")
                            .font(.caption)
                            .bold()
                            .lineLimit(1)
                            .padding(.leading, 3)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(scheme == .light ? .black : .white)
                        Spacer()
                    }
                    .padding(.vertical, 3)
                    
                    
                }
                .frame(width: 185)
                .padding(2.5)
            } //VStack
            .foregroundColor(.black)
            .frame(width: 200, height: 300)
            .padding(1)
            
        } // var body
    }
}
