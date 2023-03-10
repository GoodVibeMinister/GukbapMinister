//
//  CommentViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//
import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import Firebase
import Kingfisher
import FirebaseFirestoreSwift

//TODO: 서버에 등록된 모든 리뷰를 가져올게 아니라 특정 조건에 맞는 리뷰를 가지고올 필요가 있음
/// Description
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var reviews2: [Review] = []
    
    @Published var lastDoc: DocumentSnapshot!

   // @Published var reviewImage: [String : UIImage] = [:]
    
    @Published var reviewImageURLs: [String: URL] = [:]

    let database = Firestore.firestore()
    let storage = Storage.storage()
    
        init() {
            reviews = []
            reviews2 = []
        }
    
    //    var id: String
    //    var userId: String
    //    var reviewText: String
    //    var createdAt: Double
    //    var image: [String]?
    //    var nickName: String
    //    var createdDate: String
    //    var storeName: String
    func fetchAllReviews() {
            
            database.collection("Review")
                .order(by: "createdAt", descending: true)
                .getDocuments { (snapshot, error) in
                    self.reviews.removeAll()
                    
                    if let snapshot {
                        for document in snapshot.documents {
                            let id: String = document.documentID
                            
                            let docData = document.data()
                            let userId: String = docData["userId"] as? String ?? ""
                            let reviewText: String = docData["reviewText"] as? String ?? ""
                            let createdAt: Double = docData["createdAt"] as? Double ?? 0
                            let images: [String] = docData["images"] as? [String] ?? []
                            let nickName: String = docData["nickName"] as? String ?? ""
                            let starRating: Int = docData["starRating"] as? Int ?? 0
                            let storeName: String = docData["storeName"] as? String ?? ""
                            let storeId: String = docData["storeId"] as? String ?? ""
                            let show: Bool = docData["show"] as? Bool ?? false

                            let review: Review = Review(id: id,
                                                        userId: userId,
                                                        reviewText: reviewText,
                                                        createdAt: createdAt,
                                                        images: images,
                                                        nickName: nickName,
                                                        starRating: starRating,
                                                        storeName: storeName,
                                                        storeId: storeId,
                                                        show: show
                            )
                            
                            self.reviews.append(review)
                        }
                    }
                }
        }

    //MARK: 다음 데이터 업데이트
    func updateReviews(){

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.database.collection("Review")
                .order(by: "createdAt", descending: true)
                .start(afterDocument: self.lastDoc)
                .limit(to: 5)
                .getDocuments{(snap, err ) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                    //
                 //   self.reviews2.removeLast()

                    if !snap!.documents.isEmpty{
                        
                        for document in snap!.documents {

                            let id: String = document.documentID
                            let docData = document.data()

                            let userId: String = docData["userId"] as? String ?? ""
                            let reviewText: String = docData["reviewText"] as? String ?? ""
                            let createdAt: Double = docData["createdAt"] as? Double ?? 0
                            let images: [String] = docData["images"] as? [String] ?? []
                            let nickName: String = docData["nickName"] as? String ?? ""
                            let starRating: Int = docData["starRating"] as? Int ?? 0
                            let storeName: String = docData["storeName"] as? String ?? ""
                            let storeId: String = docData["storeId"] as? String ?? ""
                            let show: Bool = docData["show"] as? Bool ?? false

                            for imageName in images{
                                self.retrieveImages(reviewId: id, imageName: imageName)
                            }

                            let review: Review = Review(id: id,
                                                        userId: userId,
                                                        reviewText: reviewText,
                                                        createdAt: createdAt,
                                                        images: images,
                                                        nickName: nickName,
                                                        starRating: starRating,
                                                        storeName: storeName,
                                                        storeId: storeId,
                                                        show: show
                            )
                            self.reviews2.append(review)
                        }
                        self.lastDoc = snap!.documents.last
                    }// if
                    else{
                        print("마지막 리뷰 데이터")
                    }
                }
        }

        
    
    }

    // MARK: pagination ex2
    func fetchReviews() {
        
        database.collection("Review")
            .order(by: "createdAt", descending: true)
            .getDocuments { (snap, err) in
                
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
            
                 self.reviews2.removeAll()

                    for document in snap!.documents {

                        let id: String = document.documentID
                        let docData = document.data()

                        let userId: String = docData["userId"] as? String ?? ""
                        let reviewText: String = docData["reviewText"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        let images: [String] = docData["images"] as? [String] ?? []
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let starRating: Int = docData["starRating"] as? Int ?? 0
                        let storeName: String = docData["storeName"] as? String ?? ""
                        let storeId: String = docData["storeId"] as? String ?? ""
                        let show: Bool = docData["show"] as? Bool ?? false

                        for imageName in images{
                            self.retrieveImages(reviewId: id, imageName: imageName)
                        }
                        
                        let review: Review = Review(id: id,
                                                    userId: userId,
                                                    reviewText: reviewText,
                                                    createdAt: createdAt,
                                                    images: images,
                                                    nickName: nickName,
                                                    starRating: starRating,
                                                    storeName: storeName,
                                                    storeId: storeId,
                                                    show: show
                        )
                        self.reviews2.append(review)
                    }
                self.lastDoc = snap!.documents.last
            }
    }
    
    // MARK: - 서버의 Review Collection에 Review 객체 하나를 추가하여 업로드하는 Method
    func addReview(review: Review, images: [UIImage]) async {
        do {
            var imgNameList: [String] = []
            
            for img in images {
                let imgName = UUID().uuidString
                imgNameList.append(imgName)
                uploadImage(image: img, name: (review.id + "/" + imgName))
            }
            
            try await database.collection("Review")
                .document(review.id)
                .setData(["userId": review.userId,
                          "reviewText": review.reviewText,
                          "createdAt": review.createdAt,
                          "images": imgNameList,
                          "nickName": review.nickName,
                          "starRating": review.starRating,
                          "storeName" : review.storeName,
                          "storeId": review.storeId
                         ])
            
            await updateStoreRating(updatingReview: review, isDeleting: false)
            
            fetchReviews()
            fetchAllReviews()
        } catch {
            print(error.localizedDescription)
        
        }
    
    }
    
    // MARK: - 서버의 Reviews Collection에서 Reviews 객체 하나를 삭제하는 Method
    func removeReview(review: Review) async {
        do {
            try await database.collection("Review")
                .document(review.id).delete()
            
            // remove photos from storage
            if let images = review.images {
                for image in images {
                    let imagesRef = storage.reference().child("images/\(review.id)/\(image)")
                    imagesRef.delete { error in
                        if let error = error {
                            print("Error removing image from storage\n\(error.localizedDescription)")
                        } else {
                            print("images directory deleted successfully")
                        }
                    }
                }
            }
            
            await updateStoreRating(updatingReview: review, isDeleting: true)
            
            fetchReviews()
            fetchAllReviews()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 서버의 Storage에 이미지를 업로드하는 Method
    func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("images/\(name)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
        
    }

    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
//    func retrieveImages(reviewId: String, imageName: String) {
//        let ref = storage.reference().child("images/\(reviewId)/\(imageName)")
//
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        ref.getData(maxSize: 15 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("error while downloading image\n\(error.localizedDescription)")
//                return
//            } else {
//                let image = UIImage(data: data!)
//                self.reviewImage[imageName] = image
//            }
//        }
//        //
//
//    }
    func retrieveImages(reviewId: String, imageName: String) {
      
            let ref = storage.reference().child("images/\(reviewId)/\(imageName)")
            ref.downloadURL() { url, error in
                if let error = error {
                    print(#function, error.localizedDescription)
                }else if let url = url  {
                    let imageUrl = URL(string: url.absoluteString)!
                    self.reviewImageURLs[imageName] = imageUrl
                }
            }
    }


    func updateStoreRating(updatingReview: Review, isDeleting: Bool) async {
        let storeReviews = reviews.filter { $0.storeName == updatingReview.storeName }
        var reviewCount = storeReviews.count
        var ratingSum: Int = storeReviews.reduce(0) { $0 + $1.starRating}
        var newRatingAverage: Double
        
        if isDeleting {
            reviewCount -= 1
            ratingSum -= updatingReview.starRating
        } else {
            reviewCount += 1
            ratingSum += updatingReview.starRating
        }
        
      
        if reviewCount != 0 {
            newRatingAverage = Double(ratingSum) / Double(reviewCount)
        } else {
            newRatingAverage = 0
        }
        
        
        do {
            try await database.collection("Store").document(updatingReview.storeId).updateData([
                "countingStar" : newRatingAverage
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}
