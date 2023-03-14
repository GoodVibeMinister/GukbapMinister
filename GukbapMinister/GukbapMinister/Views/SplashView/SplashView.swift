//
//  SplashView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var scheme

    @State private var isActive = false



    var body: some View {

        HStack{
            if isActive{
                MainTabView()
            }else{
                ZStack{
                    let randomGukbaps = Gukbaps.allCases.shuffled().prefix(5)

                    let customColor = scheme == .light ? Color("AccentColor") : Color.black
                    customColor
                        .edgesIgnoringSafeArea(.all)
                
                    Group{
                
                        Image(randomGukbaps[0].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: -45))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:-130, y: -155)
                        Image(randomGukbaps[1].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:145, y: -30)
                        Image(randomGukbaps[2].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: -45))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:-130, y: 80)
                    }
                   

                    VStack{
                       
                            Spacer()
                        VStack{
                            Text("대한민국")
                            Text("최고 명성")
                            Text("국밥을")
                            Text("찾아라")
                        }
                        .font(.system(size: UIScreen.main.bounds.maxY * 0.07))
                        .foregroundColor(scheme == .light ? .black : .white)
                        Spacer()
         
                            VStack{
                                Text("국밥부장관")
                                Text("Goodvibe")
                            }
                            .font(.title3)
                            .foregroundColor(scheme == .light ? .black : .white)
                        .opacity(0.5)
                        
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                            self.isActive = true
                        }
                    }
                }
            }
        }
 
        
 
      
     
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
