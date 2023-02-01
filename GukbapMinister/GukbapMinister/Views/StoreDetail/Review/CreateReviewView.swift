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

struct CreateReviewView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject var reviewViewModel: ReviewViewModel
    @ObservedObject var starStore: StarStore
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] =  []
    
    @State private var isReviewAdded: Bool = false
    @State private var reviewText: String = ""
    @State private var selectedImagesDetail: Bool = false
    
    @Binding var showingSheet: Bool
    
    
    
    
    
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
                        HStack{
                            Spacer()
                            Text("")
                            Spacer()
                        }
                        HStack(spacing: 15) {
                            Spacer()
                            
                            ForEach(0..<5) { index in
                                Image(starStore.selectedStar >= index ? "Ggakdugi" : "Ggakdugi.gray")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .onTapGesture {
                                        starStore.selectedStar = index
                                    }
                            }
                            Spacer()
                        }
                        
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        Text("\(starStore.selectedStar + 1) / \(5)")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    }//VStack
                    .padding(.top,30)
                    HStack {
                        VStack(alignment: .center){
                            PhotosPicker(
                                selection: $selectedImages,
                                maxSelectionCount: 5,
                                matching: .images,
                                photoLibrary: . shared()){
                                    Image(systemName: "camera")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 25))
                                        .frame(width:70, height: 40, alignment: .center)
                                    
                                    
                                    
                                }//photoLibrary
                            HStack{
                                if selectedImages.count == 0{
                                    Text("\(selectedImages.count)")
                                        .font(.callout)
                                        .foregroundColor(selectedImages.count == 0 ? .gray : .yellow)
                                        .fontWeight(.regular)
                                        .padding(.trailing,-8)
                                    Text("/5")
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
                                    Text("/5")
                                        .font(.callout)
                                        .fontWeight(.regular)
                                }
                            }
                            .tracking(5)
                            .padding(.bottom,10)
                            .padding(.top,-10)
                            .padding(.leading,4)
                        }
                        .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.yellow,lineWidth: 1.5))
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
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
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
                                            .cornerRadius(4)
                                        // .scaledToFit()
                                            .frame(width: 70,height: 70)
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
                                                    
                                                    
                                                }
                                                
                                            }//overlay
                                    }//label
                                        
                                        
                                        //.offset(x: 5, y: -5)
                                        
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
                                
                            } // HStack
                        }//ScrollView
                        .frame(height: 70)
                    } // HStack
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 50, trailing: 20))
                    VStack {
                        Section {
                            TextField("작성된 리뷰는 우리 모두가 확인할 수 있어요. 국밥 같은 따뜻한 마음을 나눠주세요.", text: $reviewText, axis: .vertical)
                                .keyboardType(.default)
                            
                                .frame(width: 300, height: 250, alignment: .center)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                                .background(RoundedRectangle(cornerRadius: 5.0).stroke(Color.white, lineWidth: 1.5))
                                .multilineTextAlignment(.leading)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .lineLimit(11...)
                        }
                        
                        .navigationTitle("농민백암순대")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    showingSheet.toggle()
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color.black)
                                    
                                }
                            }
                            if trimReviewText.count > 0 {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action:{
                                        Task{
                                            
                                            let createdAt = Date().timeIntervalSince1970
                                            
                                            let review: Review = Review(id: UUID().uuidString,
                                                                        userId: userViewModel.userInfo.id,
                                                                        reviewText: reviewText,
                                                                        createdAt: createdAt,
                                                                        nickName: userViewModel.userInfo.userNickname,
                                                                        starRating:  starStore.selectedStar)
                                            
                                            await reviewViewModel.addReview(review: review, images: images)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                showingSheet.toggle()
                                            }
                                            isReviewAdded.toggle()
                                        }
                                    }) {
                                        Image(systemName: "plus")
                                            .foregroundColor(Color.black)
                                        
                                    }
                                }
                            }//if
                        }//toolbar
                    }//VStack
                    
                    Spacer()
                    
                }//FirstVStack
              
                
                .popup(isPresented: $isReviewAdded) {
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                        Text("리뷰가 작성되었습니다.")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .bold()
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color.yellow)
                    .cornerRadius(100)
                } customize: {
                    $0
                        .autohideIn(2)
                        .type(.floater())
                        .position(.top)
                } // popup
            }//NavigationStack
            .background(Color.white) // 화면 밖 터치할 때 백그라운드 지정을 안 해주면 View에 올라간 요소들 클릭 시에만 적용됨.
            .onTapGesture() { // 키보드 밖 화면 터치 시 키보드 사라짐
                endEditing()
            } // onTapGesture
//            .ignoresSafeArea(.keyboard, edges: .bottom)
            
            .fullScreenCover(isPresented: $selectedImagesDetail){
                ImageDetailView()
            }
            .onDisappear{
                reviewViewModel.fetchReviews()
            }
            
        }
     
    }//body
    
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

