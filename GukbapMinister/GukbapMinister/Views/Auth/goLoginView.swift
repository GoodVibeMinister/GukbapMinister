//
//  goLoginView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/24.
//

import SwiftUI

struct goLoginView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var isPresentedSheet: Bool = false // 로그인 모달 시트 트리거
    
    var body: some View {
        VStack {
            Text("로그인이 필요한 서비스입니다.\n로그인 후 이용해주세요.")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(scheme == .light ? .black : .white)
                .padding()
            
            Button {
                self.isPresentedSheet = true
            } label: { 
                Text("로그인 하러 가기")
                    .fontWeight(.semibold)
                    .foregroundColor(scheme == .light ? .white : .black)
                    .frame(width: 150, height: 40)
                    .background(Color("MainColorLight"))
                    .cornerRadius(12)
            }
            
            .sheet(isPresented: $isPresentedSheet) {
                LoginView()
                    .environmentObject(userViewModel)
            }

        }
    }
}

struct goLoginView_Previews: PreviewProvider {
    static var previews: some View {
        goLoginView()
    }
}
