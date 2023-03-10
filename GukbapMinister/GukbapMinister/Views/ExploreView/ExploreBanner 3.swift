//
//  ExploreBanner.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/02.
//

import SwiftUI

struct ExploreBanner: View {
    let bannerIndex : [String] = ["Banner1_N", "Banner2_C" , "Banner3_D" ]
    let bannerImg : [String : String] = ["Banner1_N" : "농민백암순대", "Banner2_C" : "청진옥", "Banner3_D" : "도야지 면옥"]

    
    // 배너 자동 넘기기 기능
    private let numberOfImages = 3
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(bannerIndex.enumerated()), id: \.offset) { index, img in
                ZStack (alignment: .topLeading) {
                    Image("\(img)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.75)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width * 0.75)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onReceive(timer, perform: { _ in next()})
        .onDisappear {
            self.timer.upstream.connect().cancel()
        }
    }
    
    
    func next() {
        withAnimation {
            currentIndex = currentIndex < numberOfImages ? currentIndex + 1 : 0
        }
    }
}

struct ExploreBanner_Previews: PreviewProvider {
    static var previews: some View {
        ExploreBanner()
    }
}
