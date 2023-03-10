//
//  SplashView2.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct SplashView2: View {
    @State private var isActive = false

    let foodImages = [
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
        Array(foodImages.shuffled().prefix(5))
       }
    var body: some View {
        HStack{
            if isActive{
                MainTabView()
            }else{
                VStack{
                    Spacer()
                  Image("AppIconNoText")
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width * 0.4 ,height:UIScreen.main.bounds.height * 0.2)
                    Spacer()
                    VStack{
                        Text("국밥부장관").opacity(0.5)
                        HStack{
                            ForEach(randomImages, id:\.self) { foodimage in
                                Image(foodimage)
                                    .resizable()
                                .frame(width:UIScreen.main.bounds.width * 0.09 ,height:UIScreen.main.bounds.height * 0.05)
                            }
                        }
                        .padding(.top,-15)
                     
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                
                }//VStack
                .onAppear{
                    print("\(randomImages)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.isActive = true
                    }
                }
            }
        }
      
    
    
        
    }
}

struct SplashView2_Previews: PreviewProvider {
    static var previews: some View {
        SplashView2()
    }
}
