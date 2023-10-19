//
//  FeedUpdateView.swift
//  Private
//
//  Created by yeon I on 10/18/23.


import SwiftUI
import NMapsMap
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore
import Combine
import Kingfisher

struct FeedUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var userDataStore: UserStore
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @StateObject private var postStore: PostStore = PostStore()
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    
    
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isFeedUpdateViewPresented: Bool /// FeedUpdateView
    @Binding var coord: NMGLatLng
    @Binding var searchResult: SearchResult
    
    @State private var selectedWriter: String = "김아무개"
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var textPlaceHolder: String = "수정하실 메세지를 넣어주세요" /// 텍스트마스터 placeholder
    @State private var lat: String = ""
    @State private var lng: String = ""
    
    @State private var writer: String = ""
    @State private var images: [String] = []
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var visitedShop: String = ""
    @State private var feedId: String = ""
    @State private var updatedCategory: [String] = []
    
    @State private var clickLocation: Bool = false
    @State private var isImagePickerPresented: Bool = false /// 업로드뷰에서 이미지 선택 뷰
    @State private var ImageViewPresented: Bool = true /// 처음 이미지 뷰
    @State private var showLocation: Bool = false
    @State private var isshowAlert = false /// 업로드 알럿
    @State private var categoryUpdateAlert: Bool = false /// 카테고리 초과 알럿
    @State private var isSearchedLocation: Bool = false /// 장소 검색 시트
    
    @State private var selectedImage: [UIImage]?
    @FocusState private var isTextMasterFocused: Bool
    
    //    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
//    @State private var selectedCategories: Set<MyCategory> = []
//    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    
    @State var feed: MyFeed
    
    @Binding var selectedCategory: [String]
    @State private var toUpdateCategories: Set<Category> = []
    @State private var showAlert = false
    @State private var myselectedtoupdateCategory: [MyCategory] = MyCategory.allCases
    @State private var selectedUpdateToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    private let maxSelectedCategories = 3
    
    
    private let minLine: Int = 10
    private let maxLine: Int = 12
    private let fontSize: Double = 24
//    private let maxSelectedCategories = 3
    
    private let maxSelectedToUpdateCategories = 3
    
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            if userStore.user.profileImageURL.isEmpty {
                                Circle()
                                    .frame(width: .screenWidth*0.15)
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: .screenWidth*0.15, height: .screenWidth*0.15)
                                    .foregroundColor(Color.darkGraySubColor)
                                    .clipShape(Circle())
                            } else {
                                KFImage(URL(string: userStore.user.profileImageURL))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: .screenWidth*0.15, height: .screenWidth*0.15)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(userStore.user.name)
                            Text("@\(userStore.user.nickname)")
                        }
                    }
                    .padding(.vertical, 10)
                    
                    //MARK: 내용
                    Text("")
                    TextMaster(text: $text, isFocused: $isTextMasterFocused, maxLine: minLine, fontSize: fontSize, placeholder: textPlaceHolder)
                    
                        .padding(.trailing, 10)
                    
                    //MARK: 장소
                    VStack {
                        Button {
                            showLocation = true
                        } label: {
                            Label("장소", systemImage: "location")
                        }
                        .sheet(isPresented: $showLocation) {
                            LocationSearchView(showLocation: $showLocation, searchResult: $searchResult, isSearchedLocation: $isSearchedLocation)
                                .presentationDetents([.fraction(0.75), .large])
                        }
                        .sheet(isPresented: $isSearchedLocation) {
                            LocationView(coord: $coord, searchResult: $searchResult)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    if searchResult.title.isEmpty {
                        Text("장소를 선택해주세요")
                            .font(.pretendardRegular12)
                            .foregroundColor(.secondary)
                        Text("이전 장소:")
                    } else {
                        //
                        Button {
                            lat = locationSearchStore.formatCoordinates(searchResult.mapy, 2) ?? ""
                            lng = locationSearchStore.formatCoordinates(searchResult.mapx, 3) ?? ""
                            
                            coordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                            print("위도값: \(coord.lat), 경도값: \(coord.lng)")
                            print("지정장소 클릭")
                            clickLocation.toggle()
                            coordinator.moveCameraPosition()
                            coordinator.makeSearchLocationMarker()
                        } label: {
                            Text("장소: \(searchResult.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                .font(.pretendardRegular12)
                        }
                        .sheet(isPresented: $clickLocation) {
                            LocationDetailView()
                        }
                        Text(searchResult.address)
                            .font(.pretendardRegular10)
                            .foregroundStyle(.secondary)
                        
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    //MARK: 사진
                    HStack {
                        Label("사진", systemImage: "camera")
                        Spacer()
                        Button {
                            isImagePickerPresented.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            FeedUpdateImagePickerView(selectedToUpdateImages: $selectedToUpdateImages)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white)
                                .transition(.move(edge: .leading))
                        }
                               
                    }
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .center) {
                            if let images = selectedImage, !images.isEmpty {
                                ForEach(images, id: \.self) { image in
                                    ZStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(Rectangle())
                                        Button {
                                            if let index = selectedImage?.firstIndex(of: image) {
                                                selectedImage?.remove(at: index)
                                            }
                                        } label: {
                                            ZStack {
                                                Circle()
                                                    .frame(width: .screenWidth*0.06)
                                                Image(systemName: "x.circle")
                                                    .font(.pretendardBold24)
                                                    .foregroundColor(.primary)
                                                    .padding(8)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                }
                            } else {
                                Text("최소 1장의 사진이 필요합니다!")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    //MARK: 카테고리
                    
                    HStack {
                        //Text("이전 카테고리:")
                        Text("카테고리")
                            .font(.pretendardMedium20)
                        Text("(최대 3개)")
                            .font(.pretendardRegular12)
                            .foregroundColor(.secondary)
                    }
                    FeedUpdateCateroryView(updatedCategory: [String])
                    LazyVGrid(columns:  createGridUpdateColumns(), spacing: 20) {
                        ForEach (Category.allCases.indices, id: \.self) { index in
                            VStack {
                                if selectedUpdateToggle[index] {
                                    Text(Category.allCases[index].categoryName)
                                        .font(.pretendardMedium16)
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 30)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 4)
                                        .background(Color.accentColor)
                                        .cornerRadius(7)
                                } else {
                                    Text(Category.allCases[index].categoryName)
                                        .frame(width: 70, height: 30)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 4)
                                        .cornerRadius(7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 7)
                                                .stroke(Color.darkGrayColor, lineWidth: 1.5)
                                        )
                                }
                            }
                            .onTapGesture {
                                if myselectedtoupdateCategory.count < maxSelectedToUpdateCategories || selectedUpdateToggle[index] {
                                    FeedUpdateCateroryView.toggleCategorySelection(at: index)
                                    print(myselectedtoupdateCategory)
                                } else {
                                    categoryUpdateAlert = true
                                    print("3개 초과 선택")
                                }
                            }
                            
                        }
                    }
                    .padding(.trailing, 8)
                    
                    //MARK: 수정하기
                    Text("수정하기")
                        .font(.pretendardBold18)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(text == "" || selectedImage == [] || myselectedtoupdateCategory == [] || searchResult.title.isEmpty ? Color.gray : Color.accentColor)
                        .cornerRadius(7)
                        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 13))
                        .onTapGesture {
                            isshowAlert = true
                        }
                    
                        .disabled(text == "" || selectedImage == [] || myselectedtoupdateCategory == [] || searchResult.title.isEmpty)
                } // leading VStack
                
            }
            //            .sheet(isPresented: $ImageViewPresented) {
            //                ImagePickerView(selectedImages: $selectedImage)
            //            }
            // toolbar 자리
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isFeedUpdateViewPresented = false
                        selection = 1
                        print("뷰 닫기")
                    } label: {
                        Text("취소")
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert(isPresented: $isshowAlert) {
                let firstButton = Alert.Button.cancel(Text("수정 취소")) {
                    print("취소 버튼 클릭")
                }
                /*
                 feedStore.deleteFeed(writerNickname: feed.writerNickname)
                 */
                let secondButton = Alert.Button.default(Text("수정 완료")) {
                    
                    feedStore.updateFeed(feed)
                    isFeedUpdateViewPresented = false
                    selection = 1
                    print("수정 완료 버튼 클릭")
                    
                }
                return Alert(title: Text("게시물 수정"),
                             message: Text("게시물 수정을 완료하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            
            .padding(.leading, 12)
            .navigationTitle("피드 수정하기")
            .navigationBarTitleDisplayMode(.inline)
        } // navigationStack
        .alert(isPresented: $categoryUpdateAlert) {
            Alert(
                title: Text("선택 초과"),
                message: Text("최대 3개까지 선택 가능합니다."),
                dismissButton: .default(Text("확인"))
            )
        }
        
        func toggleCategorySelection(at index: Int) {
            selectedUpdateToggle[index].toggle()
            toUpdateCategories = Set(Category.allCases.indices
                .filter { selectedUpdateToggle[$0] }
                .map { Category.allCases[$0] }
            )
        }
        
        func createGridColumns() -> [GridItem] {
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
            return columns
        }
    }
} // body




struct FeedUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(root: .constant(true), selection: .constant(3), isPostViewPresented: .constant(true), coord: .constant(NMGLatLng(lat: 36.444, lng: 127.332)), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
        
    }
}
