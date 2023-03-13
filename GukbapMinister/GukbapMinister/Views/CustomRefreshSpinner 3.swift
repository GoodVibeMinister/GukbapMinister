//
//  CustomRefreshSpinner.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct CustomRefreshSpinner: View {
    let images =  [
        "BHJGukbap",
        "KNMGukbap",
        "MudfishGukbap",
        "NJGukbap",
        "OysterGukbap",
        "PigGukbap",
        "PYOBGukbap",
        "SDGukbap",
        "SGRGukbap",
        "SJGukbap",
        "SMRGukbap",
        "SRGGukbap",
        "SRTGukbap"
    ]
    var randomImages: [String] {
        Array(images.shuffled().prefix(3))
       }
    @State private var currentIndex = 0
    @State private var rotation = 0.0
    
    var body: some View {
        VStack {
              Image(randomImages[currentIndex])
                  .resizable()
                  .frame(width: 40, height: 40)
                  .rotationEffect(.degrees(rotation))
          }
          .onAppear {
              Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                  withAnimation(Animation.linear(duration: 0.3)) {
                      currentIndex = (currentIndex + 1) % randomImages.count
                      rotation += 120
                  }
              }
          }
    }
}

//struct CustomRefreshSpinner_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomRefreshSpinner()
//    }
//}
