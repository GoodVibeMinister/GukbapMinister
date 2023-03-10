//
//  LoginView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Divider()
            Button {
                userViewModel.logoutByPlatform()
            } label: {
                Text("애플로 로그인")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(alignment:.leading) {
                        Image("AppleLogin")
                            .frame(width: 50, alignment: .center)
                    }
//                    .border(0.5, width: .black)
            }
            .background(.black)
            .cornerRadius(10)
            .padding([.leading,.trailing],5)
            
            Button {
                userViewModel.googleLogin()
            } label: {
                Text("구글로 로그인")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(alignment:.leading) {
                        Image("GoogleLogin")
                            .frame(width: 50, alignment: .center)
                    }
                    
            }
            .background(.white)
            .cornerRadius(10)
//            .border(0.5, width: .black)
//            .padding([.leading,.trailing],5)
            
            
            Button {
                userViewModel.kakaoLogin()
            } label: {
                Text("카카오 로그인")
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(alignment:.leading) {
                        Image("KakaoLogin")
                            .frame(width: 80, alignment: .center)
                    }
            }
//            .frame(width: 300, height: 40)
            .background(Color("KakaoColor"))
            .cornerRadius(10)
            .padding([.leading,.trailing],5)
            
            
            

        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
