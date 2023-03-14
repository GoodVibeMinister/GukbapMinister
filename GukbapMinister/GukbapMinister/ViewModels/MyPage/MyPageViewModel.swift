//
//  MyPageViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/03/08.
//

import Foundation

import FirebaseFirestore
import FirebaseAuth

final class MyPageViewModel: ObservableObject {
    @Published var user: User

    private let database = Firestore.firestore() // FireStore 참조 객체
    
    private var userListenerRegistration: ListenerRegistration?
    
    init(user: User = User(userNickname: "",
                           userEmail: "",
                           userGrade: "",
                           reviewCount: 0,
                           storeReportCount: 0,
                           favoriteStoreId: [])
    ) {
        self.user = user
    }
    
    //MARK: User 정보구독해제
    func unsubscribeUserInfo() {
        if userListenerRegistration != nil {
            userListenerRegistration?.remove()
            userListenerRegistration = nil
        }
    }
    
    //MARK: User 정보구독 (내용변경시 자동으로 업데이트)
    func subscribeUserInfo() {
        guard let uid =  Auth.auth().currentUser?.uid else {
            print(#function, "cannot detect user")
            return
        }
        
        if userListenerRegistration == nil {
            userListenerRegistration =
            database.collection("User")
                .document(uid)
                .addSnapshotListener { (document, error) in
                    //FirebaseFireStoreSwift 를 써서 @Document 프로퍼티를 썼더니 가능
                    if let userData = try? document?.data(as: User.self) {
                        self.user = userData
                    }
                }
        }
    }
    
 
}


