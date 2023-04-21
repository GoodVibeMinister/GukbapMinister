//
//  StoreReportViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/02/06.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseAuth


extension StoreReport {
    static var blank =
    StoreReport(userId: "",
                storeName: "",
                storeAddress: "",
                foodType: [],
                description: "",
                isUseful: false)
}

final class StoreReportViewModel: ObservableObject{
    
    enum StoreReportState {
        case yet, done, error
    }
    
    @Published var storeReport: StoreReport
    @Published var errorMessage: String = ""
    @Published var state: StoreReportState = .yet
    @Published var showPopUp: Bool = false
    
    
    private var currentUser = Auth.auth().currentUser
    private var database = Firestore.firestore()

    init(storeReport: StoreReport = .blank) {
        self.storeReport = storeReport
        
        if let uid = currentUser?.uid {
            self.storeReport.userId = uid
        }
    }
    
    private func handlePopUp(_ state: StoreReportState) {
        self.state = state
        self.showPopUp = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showPopUp = false
        }
    }
    
    
    private func addStoreReport() {
        
        do {
           let _ = try database.collection("StoreReport")
                .addDocument(from: self.storeReport)
           handlePopUp(.done)
            
        }
        catch {
            errorMessage = error.localizedDescription
            handlePopUp(.error)
        }
         
        
    }
    
    
    
    func updateFoodType(gukBap: String) {
        if storeReport.foodType.contains(gukBap) {
            if let index = storeReport.foodType.firstIndex(of: gukBap) {
                storeReport.foodType.remove(at: index)
            }
        } else {
            storeReport.foodType.append(gukBap)
        }
    }
    
    
    func handleDoneTapped() {
        if currentUser?.uid == nil {
            errorMessage = "로그인하셔서 국밥집을 제보해주세요"
            handlePopUp(.error)
        } else {
            addStoreReport()
        }
    }
    
}
