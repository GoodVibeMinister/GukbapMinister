//
//  SplashView3.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct SplashView3: View {
    @Environment(\.colorScheme) var scheme

    @State private var isActive = false
    
    // MARK: 추가할 문장이나 수정해야 할 사항들 자유롭게 작성해주세요.
    let randomText = [
        "다양하고 나만 모르는 국밥집 찾을땐?",
        "뜨뜻하고 든든한 국밥 알아볼땐?",
        "서울 부산 유명, 숨겨진 국밥집 다 먹어보자",
        "탄,단,지 영양소 풍부한 국밥 찾을땐?"
        
    ].shuffled()
    
    var body: some View {
        let randomGukbaps = Gukbaps.allCases.shuffled().prefix(5)

        HStack{
            if isActive{
                MainTabView()
            }else{
                ZStack{
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
                            .offset(x:145, y: -100)
                        
                        Image(randomGukbaps[2].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.2 ,height:UIScreen.main.bounds.height * 0.08)
                            .rotationEffect(Angle(degrees: -45))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:-10, y: 150)
                        
                        Image(randomGukbaps[3].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .offset(x:145, y: 110)
                        
                        Image(randomGukbaps[4].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.23 ,height:UIScreen.main.bounds.height * 0.1)
                            .rotationEffect(Angle(degrees: 0))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .offset(x:-130, y: 80)
                    }
                    VStack{
                        Spacer()
                        VStack{
                            
                            Text(randomText[0])
                                .font(.title3)

                            Text("국밥부장관")
                                .font(.system(size: UIScreen.main.bounds.maxY * 0.055))

                                .fontWeight(.medium)

                        }
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

struct SplashView3_Previews: PreviewProvider {
    static var previews: some View {
        SplashView3()
    }
}
