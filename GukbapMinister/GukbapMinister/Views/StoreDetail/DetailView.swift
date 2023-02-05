//
//  DetailView.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/17.
//

import SwiftUI

class StarStore: ObservableObject {
    @Published var selectedStar: Int = 0
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject private var mapViewModel: MapViewModel
    @StateObject private var reviewViewModel: ReviewViewModel = ReviewViewModel()
    @ObservedObject var starStore = StarStore()
    //@StateObject private var storeViewModel : StoreViewModel
    
    @State private var text: String = ""
    @State private var isBookmarked: Bool = false
    @State private var showingAddingSheet: Bool = false
    @State private var ggakdugiCount: Int = 0
    
    @State var startOffset: CGFloat = 0
    @State var scrollViewOffset: CGFloat = 0
    @State private var isReviewImageClicked: Bool = false

    let colors: [Color] = [.yellow, .green, .red]
    //let menus: [String : String] = ["국밥" : "9,000원", "술국" : "18,000원", "수육" : "32,000원", "토종순대" : "12,000원"]
    
    
    //lineLimit 관련 변수
    @State private var isExpanded: Bool = false
    //    @State private var truncated: Bool = false
    //    @State private var shrinkText: String
    //
    //    let font: UIFont
    //    let lineLimit: Int
    //
    //    private var moreLessText: String {
    //            if !truncated {
    //                return ""
    //            } else {
    //                return self.isExpanded ? " 접기 " : " 더보기 "
    //            }
    //        }
    
    
    var store : Store
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let width: CGFloat = geo.size.width
                

                ScrollView(showsIndicators: false) {

                    ZStack {
                        //배경색
                        Color(uiColor: .white)
                        
                        VStack{
                            //상호명 주소
                            //Store.storeName, Store.storeAddress
                            storeNameAndAddress
                            
                            //Store.images
                            storeImages(width)
                            
                            //Store.description
                            storeDescription
                            
                            //Store.menu
                            storeMenu
                            
                            // refactoring으로 인한 일시 주석처리
                            //                            NaverMapView(coordination: (37.503693, 127.053033), marked: .constant(false), marked2: .constant(false))
                            //                                .frame(height: 260)
                            //                                .padding(.vertical, 15)
                            
                            userStarRate
                            
                            ForEach(reviewViewModel.reviews) { review in
                                NavigationLink{
                                    ReviewDetailView(reviewViewModel:reviewViewModel, selectedtedReview: review)
                                }label: {
                                    if (review.storeName == store.storeName){
                                        UserReview(reviewViewModel: reviewViewModel, scrollViewOffset: $scrollViewOffset, review: review)
                                        
                                            .contextMenu{
                                                Button{
                                                    reviewViewModel.removeReview(review: review)
                                                }label: {
                                                    Text("삭제")
                                                    Image(systemName: "trash")
                                                }
                                            }//contextMenu
                                    }//NavigationLink
                                }
                            }//FirstForEach
                            
                        }//VStack
                        // .padding(.bottom, 200)
                    }//ZStack
                }//ScrollView
                .overlay(
                    GeometryReader{ proxy -> Color in
                        DispatchQueue.main.async {
                            if startOffset == 0 {
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                            let offset = proxy.frame(in: .global).minY
                            self .scrollViewOffset = offset - startOffset
                            
                            //print("y축 위치 값: \(self.scrollViewOffset)")
                        }
                        return Color.clear
                    })
                
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.backward")
                                .tint(.black)
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isBookmarked.toggle()
                        } label: {
                            Image(systemName: isBookmarked ? "heart.fill" : "heart")
                                .tint(.red)
                        }
                    }
                }
            }//GeometryReader
        }//NavigationStack
        .fullScreenCover(isPresented: $showingAddingSheet) {
            CreateReviewView(reviewViewModel: reviewViewModel, starStore: starStore,showingSheet: $showingAddingSheet, store: store )
        }
       
        .onAppear{
            reviewViewModel.fetchReviews()
            print("리뷰 이미지\(reviewViewModel.reviewImage)")
        }
        //        .onDisappear{
        //            reviewViewModel.fetchReviews()
        //        }
        .refreshable {
            reviewViewModel.fetchReviews()
        }
    }//body
}//struct

extension DetailView {
    var storeNameAndAddress: some View {
        //상호명 주소
        //Store.storeName, Store.storeAddress
        HStack {
            VStack(alignment: .leading){
                Text(store.storeName)
                    .font(.title.bold())
                    .padding(.bottom, 8)
                Text(store.storeAddress)
            }
            Spacer()
        }
        .padding(15)
        .background(.white)
    }
    
    func storeImages(_ width: CGFloat) -> some View {
        TabView {
            ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                
                VStack {
                    Text("사진\(index + 1)")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: width * 0.8)
                .background(color)
            }
        }
        .frame(height:width * 0.8)
        .tabViewStyle(.page(indexDisplayMode: .always))
        
    }
    
    
    
    var storeDescription: some View {
        VStack(alignment: .leading) {
            Group {
                Text("test 입니다. test 입니다. test 입니다. test 입니다. test 입니다. test 입니다. test 입니다. test 입니다. 자 모두들 착석해주세요~~~ 조용~ 주목")
                //                Text(store.description)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            .lineLimit(isExpanded ? nil : 2)
            
            
            HStack {
                Spacer()
                    .overlay(
                        // 여기가 문제임을 발견 2월3일 라인리밋의 후의 인덱스를 찾아서 잘 늘려주면 된다!
                        GeometryReader { proxy in
                            Button(action: {
                                isExpanded.toggle()
                            }) {
                                Text(isExpanded ? "접기" : "더보기")
                                    .font(.caption).bold()
                                //                                .background(Color.white)
                                    .foregroundColor(.blue)
                                    .padding(.leading, 8.0)
                                    .padding(.top, 4.0)
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height+30, alignment: .bottomTrailing)
                        }
                    )
                
                //            if truncated {
                //                            Button(action: {
                //                                isExpanded.toggle()
                //                            }, label: {
                //                                HStack {
                //                                    Spacer()
                //                                    Text("")
                //                                }.opacity(0)
                //                            })
                //                        }
                
                //                                .lineLimit(10)
                //                .padding(.horizontal, 15)
                //                .padding(.vertical, 30)
            }
            //
            Divider()
        }
        .background(Color.red)
        .padding(.horizontal, 15)
        .padding(.vertical, 30)
    }
    
    var storeMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("메뉴")
                    .font(.title2.bold())
                    .padding(.bottom)
                
                ForEach(/*menus.sorted(by: >)*/store.menu.sorted(by: >), id: \.key) {menu, price in
                    HStack{
                        Text(menu)
                        Spacer()
                        Text(price)
                    }
                    .padding(.bottom, 5)
                }
            }
            .padding(15)
            Divider()
        }
        .background(.white)
    }
    
    var userStarRate: some View {
        HStack {
            Spacer()
            VStack {
                Text("테디베어님의 후기를 남겨주세요")
                    .fontWeight(.bold)
                
                Spacer()
                
                //별 재사용 예정
                
                GgakdugiRatingWide(selected: starStore.selectedStar, size: 40, spacing: 15) { ggakdugi in
                    starStore.selectedStar = ggakdugi
                    showingAddingSheet.toggle()
                }
            }
            .padding(.vertical, 30)
            
            Spacer()
        }
        .background(.white)
    }
    
    
}

struct UserReview:  View {
    @StateObject var reviewViewModel: ReviewViewModel
    @ObservedObject var starStore = StarStore()
    @Binding var scrollViewOffset: CGFloat
    //var columns : [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var review: Review
    
    var body: some View {
        VStack{
            HStack{
                Text("\(review.nickName)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding()
                Spacer()
                Text("\(review.createdDate)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            HStack(spacing: -30){
                ForEach(0..<5) { index in
                    Image(review.starRating >= index ? "Ggakdugi" : "Ggakdugi.gray")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding()
                }
                Spacer()
            }//HStack
            .padding(.top,-30)
            

            

            let columns = Array(repeating: GridItem(.flexible(),spacing: -8), count: 2)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 4, content: {
             
                ForEach(Array(review.images!.enumerated()), id: \.offset) { index, imageData in
               
                    if let image = reviewViewModel.reviewImage[imageData] {
                      
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getWidth(index: index), height: getHeight(index: index))
                            .cornerRadius(5)
                        }//if let
                        
                    }// ForEach(review.images)
           
                
            })
            .padding(.leading,10)
                .padding(.top,-15)
                
                
                HStack{
                    Text("\(review.reviewText)")
                        .font(.system(size:17))
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                
                Divider()
            }//VStack
        
        }
    func getWidth(index:Int) -> CGFloat{
        let width = getRect().width - 25
        
        if (review.images?.count ?? 0) % 2 == 0{
            return width / 2
        }
  
        else{
            if index == (review.images?.count ?? 0) - 1 {
                return width + 5
            }
            else{
                return width / 2
                
            }
        }
    }
    func getHeight(index:Int) -> CGFloat{
        let height = getRect().height - 544
        
        if (review.images?.count ?? 0) == 1{
            return height
        }
        else if (review.images?.count ?? 0) == 2 {
            return height
        }
        else if (review.images?.count ?? 0) == 3 {
            return height / 2
        }
        else if (review.images?.count ?? 0) == 4 {
            return height / 2
        }
        else{
            if index == (review.images?.count ?? 0) - 1 {
                return height
            }
            else{ return height / 2
                
            }
        }
    }
    }
  
    
extension View {
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
    
    
    
    //struct DetailView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        DetailView(starStore: StarStore())
    //    }
    //}
    
