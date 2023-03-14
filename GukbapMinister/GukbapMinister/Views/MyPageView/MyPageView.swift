//
//  MyPageView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//

import SwiftUI

extension LoginState {
    var mypageImageName: String {
        switch self {
        case .googleLogin: return "mypageGoogle"
        case .appleLogin: return "mypageApple"
        case .kakaoLogin: return "mypageKakao"
        case .logout: return ""
        }
    }
    
    var mypageImage: Image {
        if self == .logout {
            return Image(systemName: "person.fill.xmark")
        } else {
            return Image(self.mypageImageName)
        }
    }
}

struct MyPageView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var storesViewModel: StoresViewModel
    
    @StateObject private var reviewViewModel = ReviewViewModel()
    @StateObject private var mypageViewModel = MyPageViewModel()
    
    @State private var showCannotAccessAlert: Bool = false
    
    var myReview : [Review] {
        reviewViewModel.reviews.filter{
            $0.userId == userViewModel.userInfo.id
        }
    }
    
    var isViceMinister: Bool {
        mypageViewModel.user.userGrade == "국밥부 차관"
    }
    
    var body: some View {
        NavigationStack {
            // 로그아웃 상태가 아니면(로그인상태이면) mypageView 띄우기
            if userViewModel.isLoggedIn {
                VStack(alignment: .leading){
                    
                    header
                    
                    List {
                        
                        NavigationLink {
                            UpdateUserInfoView()
                                .environmentObject(mypageViewModel)
                                .environmentObject(userViewModel)
                        } label: {
                            Label("회원정보 수정", systemImage: "gearshape.fill")
                        }
                        .listRowSeparator(.hidden)
                        
                        NavigationLink {
                            MyReviewView(myReview: myReview)
                                .environmentObject(storesViewModel)
                            
                        } label: {
                            HStack {
                                Label("내가 쓴 리뷰", systemImage: "pencil")
                                Spacer()
                                Text("\(myReview.count)")
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                        
                        NavigationLink {
                            NoticeView()
                        } label: {
                            Label("공지", systemImage: "exclamationmark.bubble")
                        }
                        .listRowSeparator(.hidden)
                        
                        NavigationLink {
                            PolicyView()
                        } label: {
                            Label("앱정보", systemImage: "captions.bubble")
                        }
                        .listRowSeparator(.hidden)
                        
                        NavigationLink {
                            StoreRegistrationView()
                        } label: {
                            Label("새로운 국밥집 등록하기", systemImage: isViceMinister ? "lock.open.fill" : "lock.fill")
                        }
                        .listRowSeparator(.hidden)
                        .disabled(!isViceMinister)
                        .simultaneousGesture(TapGesture().onEnded{
                            if !isViceMinister {
                                showCannotAccessAlert = true
                            }
                        })
                        .alert("국밥부차관이 되어보세요!", isPresented: $showCannotAccessAlert) {
                            Button("확인") {
                                showCannotAccessAlert = false
                            }
                        } message: {
                            Text("국밥부차관 이상 등급의 사용자는 직접 국밥집 등록을 할 수 있습니다.\n 자세한 사항은 공지를 확인해주세요.")
                        }
                        
                        Button {
                            userViewModel.logoutByPlatform()
                        } label: {
                            Label("로그아웃", systemImage: "xmark.circle")
                        }
                        .padding(1.5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    
                }
                .navigationTitle("마이페이지")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    reviewViewModel.fetchAllReviews()
                    mypageViewModel.subscribeUserInfo()
                }
                .onDisappear {
                    mypageViewModel.unsubscribeUserInfo()
                }
                
            } else {
                goLoginView()
                    .environmentObject(userViewModel)
            }
        }
        .tint(.mainColor)
    }
    
    private var header: some View {
        HStack(alignment: .center){
            Circle()
                .fill(.gray.opacity(0.1))
                .frame(width: 75, height: 75)
                .overlay{
                    Image("Ddukbaegi.fill")
                        .foregroundColor(.accentColor)
                        .font(.largeTitle)
                }
                .padding(.leading, 20)
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(mypageViewModel.user.userNickname)")
                        .font(.title3)
                    
                    userViewModel.loginState.mypageImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    
                    Spacer()
                    
                    Text("\(mypageViewModel.user.userGrade)")
                        .font(.body)
                        .padding(.trailing, 20)
                }
                .padding(.leading, 10)
                .padding(.bottom, 1)
                
                HStack{
                    Text(mypageViewModel.user.userEmail)
                        .font(.caption)
                        .padding(.leading, 10)
                }
            }
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3),lineWidth: 1)
                .frame(width: Screen.maxWidth * 0.9217, height: Screen.maxHeight * 0.1355)
        )
        .padding()
        .padding(.vertical)
    }
}




