//
//  SplashView3.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct SplashView3: View {
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
           Array(foodImages.shuffled())
       }
    var body: some View {
        HStack{
            if isActive{
                MainTabView()
            }else{
                ZStack{
                    Color("AccentColor")
                        .ignoresSafeArea(.all)
                    Group{
                        
                        Image(randomImages[0])
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: -45))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:-130, y: -155)
                        
                        Image(randomImages[1])
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:145, y: -100)
                        
                        Image(randomImages[2])
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.2 ,height:UIScreen.main.bounds.height * 0.08)
                            .rotationEffect(Angle(degrees: -45))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:-10, y: 150)
                        
                        Image(randomImages[3])
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:145, y: 110)
                        
                        Image(randomImages[4])
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .offset(x:-130, y: 80)
                    }
                    VStack{
                        Spacer()
                        VStack{
                            
                            Text("뜨뜻하고 든든한 국밥 알아볼땐? ")
                                .font(.title3)
                            Text("국밥부장관")
                                .font(.system(size: UIScreen.main.bounds.maxY * 0.055))
                                .fontWeight(.medium)

                        }.foregroundColor(.white)

                           
                            Spacer()
             
                                VStack{
                                    Text("국밥부장관")
                                    Text("Goodvibe")
                                }
                                .font(.title3)
                                .foregroundColor(.white)
                            .opacity(0.5)
                            
                        }
                    }
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

struct SplashView3_Previews: PreviewProvider {
    static var previews: some View {
        SplashView3()
    }
}
