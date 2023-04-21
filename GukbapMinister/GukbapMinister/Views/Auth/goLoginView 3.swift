//
//  goLoginView.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/24.
//

import SwiftUI

struct goLoginView: View {
    
    @EnvironmentObject private var userViewModel: UserViewModel
    
    @State private var isPresentedSheet: Bool = false // 로그인 모달 시트 트리거
    
    var body: some View {
        VStack {
            Button {
                self.isPresentedSheet = true
            } label: {
                Text("로그인이 필요한 서비스 입니다.")
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
