//
//  SplashView4.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/05.
//

import SwiftUI

struct SplashView4: View {
    @Environment(\.colorScheme) var scheme

    @State private var isActive = false
    
    
    var body: some View {
        let randomGukbaps = Gukbaps.allCases.shuffled()

        HStack{
            if isActive{
                MainTabView()
            }else{
                ZStack{
                    let customColor = scheme == .light ? Color("AccentColor") : Color.black
                    customColor
                        .edgesIgnoringSafeArea(.all)

                    VStack{
                        Spacer()
                        VStack{
                            HStack{
                                Text("내 주변")
                                Spacer()
                            }
                            .font(.system(size: UIScreen.main.bounds.maxY * 0.045))
                            
                            HStack{
                                Text("국밥 찾을땐?")
                                Spacer()
                            }
                            .font(.system(size: UIScreen.main.bounds.maxY * 0.045))

                            HStack{
                                Text("국밥부장관")
                                Spacer()
                            }
                            .font(.system(size: UIScreen.main.bounds.maxY * 0.045))
                            .fontWeight(.medium)

                          

                        }
                            .padding(.leading,30)
                        Image(randomGukbaps[0].imageName)
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.85 ,height:UIScreen.main.bounds.height * 0.4)
                            .rotationEffect(Angle(degrees: -0))
                            .offset(x:0, y: 0)
                           
                            Spacer()
             
                                VStack{
                                    Text("국밥부장관")
                                    Text("Goodvibe")
                                }
                                .font(.title3)
                            .opacity(0.5)
                            
                        }
                    .foregroundColor(scheme == .light ? .black : .white)

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

struct SplashView4_Previews: PreviewProvider {
    static var previews: some View {
        SplashView4()
    }
}
