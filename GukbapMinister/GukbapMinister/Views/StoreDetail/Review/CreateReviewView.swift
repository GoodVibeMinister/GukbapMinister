//
//  CreateReviewView.swift
//  GukbapMinister
//
//  Created by 이원형 on 2023/01/17.
//

import SwiftUI
import PhotosUI
import PopupView
import Shimmer
import FirebaseAuth

struct CreateReviewView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject var reviewViewModel: ReviewViewModel
    
    @Binding var selectedStar: Int
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] =  []
    
    @State private var isReviewAdded: Bool = false
    @State private var reviewText: String = ""
    @State private var selectedImagesDetail: Bool = false
    
    @Binding var showingSheet: Bool
    @State var value : CGFloat = 0
    
    var store : Store
    
    
    var trimReviewText: String {
        reviewText.trimmingCharacters(in: .whitespaces)
    }
    var images: [UIImage]  {
        var uiImages: [UIImage] = []
        if !selectedImageData.isEmpty {
            for imageData in selectedImageData {
                if let image = UIImage(data: imageData) {
                    uiImages.append(image)
                }
            }
        }
        return uiImages
    }
    var body: some View {
        NavigationStack {
        
            ScrollView{
                VStack{
                    VStack{
                       
                        HStack(spacing: 15) {
                            Spacer()
                            GgakdugiRatingWide(selected: selectedStar, size: 40, spacing: 15) { star in
                                selectedStar = star
                            }
                            Spacer()
                        }
                        
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        Text("\(selectedStar + 1) / \(5)")
                            .foregroundColor(scheme == .light ? .black : .white)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    }//VStack
                    .padding(.top,30)
                    HStack {
                        VStack(alignment: .center){
                            PhotosPicker(
                                selection: $selectedImages,
                                maxSelectionCount: 4,
                                matching: .images,
                                photoLibrary: . shared()){
                                    Image(systemName: "camera")
                                        .foregroundColor(Color("AccentColor"))
                                        .font(.system(size: 25))
                                        .frame(width:80, height: 45, alignment: .center)
                                    
                                    
                                    
                                }//photoLibrary
                            HStack{
                                if selectedImages.count == 0{
                                    Text("\(selectedImages.count)")
                                        .font(.callout)
                                        .foregroundColor(selectedImages.count == 0 ? .gray : Color("AccentColor"))
                                        .fontWeight(.regular)
                                        .padding(.trailing,-8)
                                    Text("/4")
                                        .font(.callout)
                                        .fontWeight(.regular)
                                }
                                else {
                                    Text("\(selectedImages.count)")
                                        .font(.callout)
                                        .foregroundColor(selectedImages.count == 0 ? .gray : .black)
                                        .fontWeight(.regular)
                                        .padding(.trailing,-8)
                                    //                                    .shimmering(
                                    //                                        animation: .easeInOut(duration: 2).repeatCount(5, autoreverses: false).delay(1)
                                    //                                    )
                                    Text("/4")
                                        .font(.callout)
                                        .fontWeight(.regular)
                                }
                            }
                            .tracking(5)
                            .padding(.bottom,10)
                            .padding(.top,-10)
                            .padding(.leading,4)
                        }
                        .background(RoundedRectangle(cornerRadius:10.0).stroke(Color("AccentColor"),lineWidth: 1.5))
                        .onChange(of: selectedImages) { items in
                            //선택된 이미지 없으면 배열 초기화
                            if items.isEmpty { selectedImageData = [] }
                            
                            for item in items {
                                Task {
                                    selectedImageData = []
                                    if let data = try? await
                                        item.loadTransferable(type: Data.self) {
                                        selectedImageData.append(data)
                                        
                                    }
                                }//Task
                            }//for
                        }//.onChanged
                        .padding(.leading,7)
                        VStack(alignment: .leading, spacing: 10){
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .center, spacing: 10){
                                    // 선택된 이미지 출력.
                                    //  ForEach(selectedImageData, id: \.self) { imageData in
                                    ForEach(Array(selectedImageData.enumerated()), id: \.offset) { index, imageData in
                                        if let image = UIImage(data: imageData) {
                                            NavigationLink {
                                                ImageDetailView()
                                            }
                                        label:{
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80,height: 80)
                                                .cornerRadius(4)
                                            
                                                .overlay(alignment: .topTrailing) {
                                                    Button(action: {
                                                        selectedImageData.remove(at:index)
                                                        selectedImages.remove(at: index)
                                                        
                                                    }) {
                                                        Circle()
                                                            .frame(width: 17, height: 17)
                                                            .foregroundColor(.black)
                                                            .overlay {
                                                                Image(systemName: "xmark")
                                                                    .font(.system(size: 12))
                                                                    .foregroundColor(.white)
                                                                
                                                            }
                                                            .offset(x:7,y:-7)
                                                    }
                                                    
                                                }//overlay
                                        }//label
                                            
                                            
                                            
                                        .overlay(alignment: .bottom) {
                                            if (selectedImages.first != nil) {
                                                if (selectedImageData.first != nil) {
                                                    if index == 0 {
                                                        Text("대표 사진")
                                                            .font(.system(size:12))
                                                            .fontWeight(.regular)
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 20)
                                                            .foregroundColor(Color.white)
                                                            .background { Color.black }
                                                            .cornerRadius(4)
                                                            .shimmering(
                                                                animation: .easeInOut(duration: 2).repeatCount(3, autoreverses: false).delay(0.5)
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                        } // if let
                                        
                                    } // FirstForEach
                                }//HStack
                                .frame(height: 100)
                            }//ScrollView
                            
                        }
                        
                    } // HStack
                    .padding(EdgeInsets(top: 30, leading: 15, bottom: 50, trailing: 15))
                    VStack {
                        Section {
                            TextField("작성된 리뷰는 우리 모두가 확인할 수 있어요. 국밥 같은 따뜻한 마음을 나눠주세요.", text: $reviewText, axis: .vertical)
                                .keyboardType(.default)
                                .frame(width: 300, height: 250, alignment: .center)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                                .background(RoundedRectangle(cornerRadius: 5.0).stroke(scheme ==  .light ? Color.mainColor : Color.white, lineWidth: 1.5))
                                .multilineTextAlignment(.leading)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .lineLimit(11...)
                        }
                        
                        //                        .navigationTitle(store.storeName)
                        //                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                VStack {
                                    Text("\(store.storeName)").font(.headline)
                                    Text("\(store.storeAddress)").font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    showingSheet.toggle()
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(scheme == .light ? .black : .white)
                                }
                            }
                            if trimReviewText.count > 0 &&  isReviewAdded == false {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action:{

                                        Task{
                                            
                                            let createdAt = Date().timeIntervalSince1970
                                            
                                            let review: Review = Review(id: UUID().uuidString,
                                                                        userId: userViewModel.userInfo.id ?? "",
                                                                        reviewText: reviewText,
                                                                        createdAt: createdAt,
                                                                        nickName: userViewModel.userInfo.userNickname,
                                                                        starRating:  selectedStar + 1,
                                                                        storeName: store.storeName,
                                                                        storeId: store.id ?? "",
                                                                        show: false
                                            )
                                            
                                            await reviewViewModel.addReview(review: review,
                                                                            images: images)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                                showingSheet.toggle()
                                            }
                                            isReviewAdded.toggle()
                                        }
                                    }) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color("AccentColor"))
                                    }
                                }
                            }//if
                        }//toolbar
                    }//VStack
                   
                    Spacer()
                    
                }//FirstVStack
                
                .offset(y: -self.value)
                .animation(.spring(),value: value)
                .onAppear{
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,object:nil,queue:.main){
                        (noti) in
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        self.value = height - 75
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,object:nil,queue:.main){
                            (noti) in
                            
                            self.value = 0
                        }
                    }
                }
                
                .popup(isPresented: $isReviewAdded) {
                    HStack {
                        Image(uiImage: (Gukbaps(rawValue: store.foodType.first ?? "순대국밥")?.uiImage!)!)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.13,
                                   height: UIScreen.main.bounds.height * 0.05 )
                        Text("\(userViewModel.userInfo.userNickname)님의 소중한 리뷰가 작성되었습니다.")
                            .foregroundColor(.black)
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .background(Color("AccentColor").opacity(0.85))
                    .cornerRadius(100)
                } customize: {
                    $0
                        .autohideIn(1.3)
                        .animation(.spring())
                        .type(.floater(verticalPadding: 0, useSafeAreaInset: true))
                        .position(.top)
                } // popup
            }//ScrollView
            .padding(.top, getSafeAreaTop())
            .offset(y:-50)

         

            .background(scheme == .light ? .white : .black) // 화면 밖 터치할 때 백그라운드 지정을 안 해주면 View에 올라간 요소들 클릭 시에만 적용됨.
            .onTapGesture() { // 키보드 밖 화면 터치 시 키보드 사라짐
                endEditing()
            } // onTapGesture
            //            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear{
//                userViewModel.fetchUserInfo(uid: Auth.auth().currentUser?.uid ?? "")
            }
            .fullScreenCover(isPresented: $selectedImagesDetail){
                ImageDetailView()
            }
            .onDisappear{
                reviewViewModel.fetchReviews()
                reviewViewModel.fetchAllReviews()

            }
            
        }
        .animation(.easeInOut, value:selectedImageData)
       
    }//body
    func getSafeAreaTop() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return (keyWindow?.safeAreaInsets.top)!
    }

}//struct CreateReviewView



extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}







//struct CreateReviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateReviewView(selected: Binding<0>)
//    }
//}


