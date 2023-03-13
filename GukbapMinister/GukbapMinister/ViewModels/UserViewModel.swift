//
//  LoginViewModel.swift
//  GukbapMinister
//
//  Created by 전혜성 on 2023/02/23.
//

import Foundation
import UIKit
import CryptoKit
import SwiftUI
import AuthenticationServices

import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

import KakaoSDKAuth
import KakaoSDKUser


// MARK: - 주의사항
// 카카오로그인 진행시 로그인이 안될 때 카카오디벨로퍼 -> 플랫폼 -> 번들아이디 수정

// TODO: - 해야할 일
// 애플로그인

// MARK: - 로그인상태 열거형
enum LoginState: String {
    case googleLogin = "googleLogin"
    case kakaoLogin
    case appleLogin
    case logout
}

// MARK: -
class UserViewModel: NSObject, ObservableObject {
    
    // MARK: - 프로퍼티
    let database = Firestore.firestore() // FireStore 참조 객체
    let currentUser = Auth.auth().currentUser
    
    var currentNonce: String? = nil
    var window: UIWindow? = nil
    
    // MARK: - @Published 변수
    @Published var loginState: LoginState = .logout // 로그인 상태 변수
    @Published var userInfo: User = User() // User 객체
    
    // MARK: - 자동로그인을 위한 UserDefaults 변수
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @AppStorage("loginPlatform") var loginPlatform: String = (UserDefaults.standard.string(forKey: "loginPlatform") ?? "")
    
    
    override init() {
        super.init()
        if self.isLoggedIn && currentUser != nil {
            self.fetchUserInfo(uid: self.currentUser?.uid ?? "")
            self.loginState = LoginState(rawValue: loginPlatform) ?? .logout
        }
    }
    
    
    
    // MARK: 사용자 정보 가져오기
    func fetchUserInfo(uid: String) {
        let docRef = database.collection("User").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                if let data = try? document.data(as: User.self) {
                    self.userInfo = data
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // MARK: - FireStore에 유저 정보 추가하는 함수
    func insertUserInFirestore(userEmail: String, userName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Task {
            do {
                let document = try await database.collection("User").document(uid).getDocument()
                
                if document.exists {
                    try database.collection("User").document(uid).setData(from: document.data(as: User.self))
                } else {
                    try await database.collection("User").document(uid).setData([
                        "userEmail" : userEmail,
                        "userNickname" : userName,
                        "reviewCount" : 0,
                        "storeReportCount" : 0,
                        "favoriteStoreId" : [],
                        "userGrade" : "깍두기"
                    ])
                }
                
                self.fetchUserInfo(uid: uid)
            } catch {
                print("\(#function) 파이어베이스 에러 : \(error.localizedDescription)")
            }
        }//Task
    }
    
    // MARK: - 구글
    // 구글 로그인
    @MainActor
    func googleLogin() async {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 구글 로그인 로직 실행
        do {
            let googleUserInfo = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController).user
            
            guard
                let idToken = googleUserInfo.idToken?.tokenString else {
                print(#function, "there is no token")
                return
            }
            let accessToken = googleUserInfo.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let user = try await Auth.auth().signIn(with: credential).user
                 
            self.insertUserInFirestore(userEmail: user.providerData.first?.email ?? "", userName: user.providerData.first?.displayName ?? "")
            
            setUserDefaults(.googleLogin)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 카카오
    // 카카오 로그인
    func kakaoLogin() {
        // 카카오톡 간편로그인이 실행 가능한지 확인
        func loginProcess(_ oauthToken: OAuthToken?, _ error: Error?) {
            if let error = error {
                print("There is some error in Kakao Service: \(error)")
            } else {
                doKakaoAuthFirebaseProcess { error in
                    if let error {
                        print("Cannot do KakaoAuthFirebaseProcess: \(error)")
                    } else {
                        self.setUserDefaults(.kakaoLogin)
                    }
                }
            }
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            // 간편로그인 실행 가능할 경우
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
               loginProcess(oauthToken, error)
            }
        } else { // 간편로그인이 실행 불가능할 경우
            // 로그인 웹페이지를 띄우고 쿠키기반 로그인 진행
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                loginProcess(oauthToken, error)
            }
        }
    }
    
    private func doKakaoAuthFirebaseProcess(completion: @escaping (Error?) -> Void) {
        getKakaoUserInfo { [self] (id, account, error) in
            if let error {
                completion(error)
                return
            }
            
            if let id, let account, let email = account.email {
                self.database.collection("User").whereField("userEmail", isEqualTo: email).getDocuments { result, error in
                    if let error {
                        completion(error)
                        return
                    }
                    if let result {
                        if result.isEmpty {
                            Auth.auth().createUser(withEmail: email, password: String(id)) { _, error in
                                if let error {
                                    completion(error)
                                    return
                                }
                                self.insertUserInFirestore(userEmail: email, userName: account.name ?? "")
                            }
                        } else {
                            Auth.auth().signIn(withEmail: email, password: String(id)) { _, error in
                                if let error {
                                    completion(error)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Firebas Auth, Store 저장
    // kakaoLogin() 함수 내에서 사용
    private func getKakaoUserInfo(completion: @escaping (Int64?, Account?, Error?) -> Void) {
        // 사용자 정보 가져오기
        UserApi.shared.me { (kuser, error) in
            if let error {
                completion(nil, nil, error)
                return
            }
            
            guard let kuser,
                  let kakaoAccount = kuser.kakaoAccount,
                  let kakaoUid = kuser.id
            else {
                completion(nil, nil, nil)
                return
            }
            
            completion(kakaoUid, kakaoAccount, nil)
        }
    }
    
   
                
    
    
    //MARK: - UserDefaults 값 저장
    private func setUserDefaults(_ loginState: LoginState) {
        self.loginState = loginState
        
        if loginState != .logout {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        } else {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
        
        UserDefaults.standard.set(loginState.rawValue, forKey: "loginPlatform")
    }
    
    // MARK: - 로그아웃(공통)
    // 로그인 상태 열거형 변수를 참조하여 해당하는 플랫폼 로그아웃 로직 실행
    func logoutByPlatform() {
        
        switch loginPlatform {
        case "googleLogin", "appleLogin": // 구글, 애플 로그인일때
            do {
                try Auth.auth().signOut()
                
                self.setUserDefaults(.logout)
                
            } catch {
                print("Error signing out: %@", error.localizedDescription)
            }
            
        case "kakaoLogin":
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    do {
                        try Auth.auth().signOut()
                       
                        self.setUserDefaults(.logout)
                        
                    } catch {
                        print("Error signing out: %@", error.localizedDescription)
                    }
                }
            }
            default: return
        }
    }
}

extension UserViewModel {
    func startAppleLogin() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension UserViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        print("여기 호출됩니다!")
        //애플
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }

        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce)

            Auth.auth().signIn(with: credential) { result, error in
                // 사용자 uid
                guard let user = result?.user else { return }
                // 로그인 성공시 유저정보 FireStore에 저장
                self.insertUserInFirestore(userEmail: user.providerData.first?.email ?? "", userName: user.providerData.first?.displayName ?? "")
                
            }
          
          setUserDefaults(.appleLogin)
            
        }
      }
    }


extension UserViewModel:
    ASAuthorizationControllerPresentationContextProviding {
      public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
          window!
      }
}
