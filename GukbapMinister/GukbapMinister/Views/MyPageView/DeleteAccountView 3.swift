//
//  DeleteAccountView.swift
//  GukbapMinister
//
//  Created by 김요한 on 2023/02/23.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isShowingAlert.toggle()
                } label: {
    //                Image(systemName: "xmark.circle")
                    Text("회원탈퇴")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                .alert("회원탈퇴", isPresented: $isShowingAlert) {
                    Button("확인", role: .cancel) {
//                        userViewModel.deleteUser()
                    }
                    Button("취소", role: .destructive) {
                        
                    }
                } message: {
                    Text("사용자의 정보가 즉시 삭제됩니다. \n 회원탈퇴를 진행하시겠습니까?")
                }
                Spacer()
            }
            
            Spacer()
        }
        .padding(15)
        
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
