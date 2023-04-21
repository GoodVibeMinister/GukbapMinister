//
//  LoginView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.window) var window: UIWindow?
    @EnvironmentObject var userViewModel: UserViewModel
    
    
    var body: some View {
        ZStack {
            Color("MainColorLight")
                .edgesIgnoringSafeArea(.all)
            
            AnimationLoginView()
            
            VStack {
                VStack(spacing: 0) {
                    Text("국밥부장관")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image("AppIconNoText")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
                VStack {
                    Button {
                        appleLogin()
                    } label: {
                        Text("Apple로 로그인")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(alignment:.leading) {
                                Image("AppleLogin")
                                    .frame(width: 50, height: 70, alignment: .center)
                            }
                    }
                    .background(.black)
                    .cornerRadius(12)
                    .padding([.leading,.trailing],5)
                    
                    Button {
                        Task {
                            await userViewModel.googleLogin()
                        }
                    } label: {
                        Text("Google로 로그인")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(alignment:.leading) {
                                Image("GoogleLogin")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(.leading, 10)
                            }
                        
                    }
                    .background(.white)
                    .cornerRadius(12)
                    .padding([.leading,.trailing],5)
                    
                    Button {
                        userViewModel.kakaoLogin()
                    } label: {
                        Text("카카오로 로그인")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(alignment:.leading) {
                                Image("KakaoLogin")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .padding(.leading, 12)
                            }
                    }
                    .background(Color("KakaoColor"))
                    .cornerRadius(12)
                    .padding([.leading,.trailing],5)
                    
                }
                .frame(width: 330)
                .padding(.top, 100)
                
                
            }
            .zIndex(1)
        }
    }
    
    
    func appleLogin() {
        if let window {
            userViewModel.window = window
        }
        userViewModel.startAppleLogin()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
