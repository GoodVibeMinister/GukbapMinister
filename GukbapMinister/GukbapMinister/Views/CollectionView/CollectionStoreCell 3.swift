//
//  CollectionLikedStoreCell.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import SwiftUI
import Kingfisher

struct CollectionStoreCell: View {
    @Environment(\.colorScheme) var scheme
    @StateObject var viewModel = DetailViewModel(store: .test)
    
    
    var rowOne: [GridItem] = Array(repeating: .init(.fixed(50)), count: 1)
    
    @State private var isLoading = true
    
    
    var body: some View {
        VStack {
            NavigationLink {
                DetailView(detailViewModel: DetailViewModel(store: viewModel.store))
            } label: {
                HStack(alignment: .top) {
                    StoreImageThumbnail(manager: StoreImageManager(store: viewModel.store), width: 120, height: 120, cornerRadius: 6, mode: .tab)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack{
                            Text(viewModel.store.storeName)
                                .font(.title3)
                                .bold()
                                .padding(.top, 3)
                            Spacer()
                            
                            Button{
                                viewModel.handleLikeButton()
                            } label: {
                                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Text(viewModel.store.storeAddress)
                            .font(.caption)
                            .padding(.top, 3)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(alignment: .center){
                            GgakdugiRatingShort(rate: viewModel.store.countingStar , size: 15)
                            Spacer()
                        }
                        .padding(.top, 5)
                        .frame(height: 20)
                        
                        HStack{
                            LazyHGrid(rows: rowOne) {
                                ForEach(viewModel.store.foodType, id: \.self) { foodType in
                                    Text("\(foodType)")
                                        .font(.caption)
                                        .padding(8)
                                        .background(Capsule().fill(Color.gray.opacity(0.15)))
                                }
                            }
                        }
                    }
                }
                .padding(10)
                .foregroundColor(scheme == .light ? .black : .white)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray.opacity(0.3))
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 36)
        .padding(.vertical,5)
        .redacted(reason: isLoading ? .placeholder : [])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
        }
    }
    
}


