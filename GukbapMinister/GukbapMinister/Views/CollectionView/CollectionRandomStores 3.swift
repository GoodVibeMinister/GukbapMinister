//
//  CollectionRandomStores.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/03.
//

import SwiftUI

struct CollectionRandomStores: View {
    @EnvironmentObject var storesViewModel: StoresViewModel
    
    var stores: [Store] {
        storesViewModel.stores
    }
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("찜한 곳이 없네요")
                    Spacer()
                }
                HStack{
                    Text("추천하는 국밥집은 어떠신가요?")
                    Spacer()
                    
                }
            }
            .font(.callout)
            .bold()
            .padding(.leading)
            
            ForEach(stores.shuffled().prefix(5), id: \.self){ store in
                CollectionStoreCell(viewModel: DetailViewModel(store: store))
            }
        }
        
    }
}

struct CollectionRandomStores_Previews: PreviewProvider {
    static var previews: some View {
        CollectionRandomStores()
    }
}
