//
//  StoreModalView.swift
//  GukbapMinister
//
//  Created by TEDDY on 1/18/23.
//

import SwiftUI

struct StoreModalView: View {
  @EnvironmentObject private var mapViewModel: MapViewModel
  @State private var isHeart : Bool = false
  
  var store: Store = .test
  
  var body: some View {
    NavigationStack {
      VStack {
        HStack{
          Text(store.storeName)
            .font(.title2)
            .bold()
            .padding(.leading, 20)
          
          Spacer()
        }
        
        NavigationLink(destination: DetailView(store: store)) {
          HStack {
            AsyncImage(url: URL(string: store.storeImages.isEmpty ? "이미지 없음" : store.storeImages[0])) { image in
              image
                .resizable()
            } placeholder: {
              Color.gray.opacity(0.1)
            }
            .frame(width: 100, height: 100)
            .cornerRadius(6)
            .padding(.leading, 20)
            
            VStack{
              HStack {
                Image("Ggakdugi")
                  .resizable()
                  .scaledToFill()
                  .frame(width: 20, height: 20)
                Text("\(store.countingStar)")
                  .font(.title3)
                
                Spacer()
              }
              
              HStack(alignment: .top){
                Text(store.storeAddress)
                  .bold()
                  .padding(.leading, 5)
                
                Spacer()
              }
              .padding(.trailing, 20)
            }
            .padding(.horizontal, 5)
          }
          .background {
            Rectangle()
              .frame(maxWidth: .infinity)
              .frame(height: 120)
              .foregroundColor(Color.white)
              .opacity(0.2)
          }
        }
      }
      //      }.frame().background(.orange)
    }
  }
}

struct StoreModalView_Previews: PreviewProvider {
  static var previews: some View {
    StoreModalView()
  }
}
