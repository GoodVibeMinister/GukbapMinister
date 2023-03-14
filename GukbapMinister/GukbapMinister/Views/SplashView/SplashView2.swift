//
//  SplashView2.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/03/04.
//

import SwiftUI

struct SplashView2: View {
    @Environment(\.colorScheme) var scheme

    @State private var isActive = false


    var body: some View {
        let randomGukbaps = Gukbaps.allCases.shuffled().prefix(5)

        HStack{
            if isActive{
                MainTabView()
            }else{
                ZStack {
                    let customColor = scheme == .light ? Color("AccentColor") : Color.black
                    customColor
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Spacer()
                      Image("AppIconNoText")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width * 0.4 ,height:UIScreen.main.bounds.height * 0.2)
                   
                        Spacer()
                        VStack{
                            Text("국밥부장관").opacity(0.5)

                            HStack{
                                ForEach(randomGukbaps, id:\.self) { foodimage in
                                    Image(foodimage.imageName)
                                        .resizable()
                                    .frame(width:UIScreen.main.bounds.width * 0.11 ,height:UIScreen.main.bounds.height * 0.05)
                                }
                            }
                            .padding(.top,-15)
                         
                        }
                        .font(.title3)
                        .foregroundColor(scheme == .light ? .black : .white)

                    
                    }//VStack
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

struct SplashView2_Previews: PreviewProvider {
    static var previews: some View {
        SplashView2()
    }
}
