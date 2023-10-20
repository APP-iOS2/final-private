//
//  PostView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI
import NMapsMap
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore
import Combine
import Kingfisher

struct PostView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var userDataStore: UserStore
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @StateObject private var postStore: PostStore = PostStore()
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var searchResult: SearchResult
    
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var textPlaceHolder: String = "나만의 Private한 장소에 대해 적어주세요!" /// 텍스트마스터 placeholder
    @State private var lat: String = ""
    @State private var lng: String = ""
    @State private var newMarkerlat: String = ""
    @State private var newMarkerlng: String = ""
    
    @State private var writer: String = ""
    @State private var images: [String] = []
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var visitedShop: String = ""
    @State private var feedId: String = ""
    @State private var myselectedCategory: [String] = []
    
    @State private var clickLocation: Bool = false
    @State private var isImagePickerPresented: Bool = false /// 업로드뷰에서 이미지 선택 뷰
    @State private var ImageViewPresented: Bool = true /// 처음 이미지 뷰
    @State private var showLocation: Bool = false
    @State private var isshowAlert = false /// 업로드 알럿
    @State private var categoryAlert: Bool = false /// 카테고리 초과 알럿
    @State private var isSearchedLocation: Bool = false /// 장소 검색 시트
    @State private var registrationAlert: Bool = false /// 신규 장소 저장완료 알럿

    @State private var selectedImage: [UIImage]? = []
    @FocusState private var isTextMasterFocused: Bool

    @State private var selectedCategories: Set<MyCategory> = []
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    
    private let minLine: Int = 10
    private let maxLine: Int = 12
    private let fontSize: Double = 18
    private let maxSelectedCategories = 3
    
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    let filteredCategories = Category.filteredCases
    
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
                    TextMaster(text: $text, isFocused: $isTextMasterFocused, maxLine: minLine, fontSize: fontSize, placeholder: textPlaceHolder)
                    
                        .padding(.trailing, 10)
                    
                    //MARK: 장소
                    VStack {
                        Button {
                            showLocation = true
                        } label: {
                            Label("장소", systemImage: "location")
                                .font(.pretendardMedium18)
                                .foregroundStyle(Color.privateColor)
                        }
                        .sheet(isPresented: $showLocation) {
                            LocationSearchView(showLocation: $showLocation, searchResult: $searchResult, isSearchedLocation: $isSearchedLocation)
                                .presentationDetents([.fraction(0.75), .large])
                        }
                        .sheet(isPresented: $isSearchedLocation) {
                            LocationView(searchResult: $searchResult, registrationAlert: $registrationAlert, newMarkerlat: $newMarkerlat, newMarkerlng: $newMarkerlng, isSearchedLocation: $isSearchedLocation)
                        }
                    }
                    .padding(.vertical, 10)
                      
                    HStack {
                        VStack(alignment: .leading) {
                            if searchResult.title.isEmpty && postCoordinator.newMarkerTitle.isEmpty {
                                Text("장소를 선택해주세요")
                                    .font(.pretendardRegular16)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 5)
                            } else {
                                Button {
                                    if !postCoordinator.newMarkerTitle.isEmpty {
                                        clickLocation.toggle()
                                    } else {
                                        lat = locationSearchStore.formatCoordinates(searchResult.mapy, 2) ?? ""
                                        lng = locationSearchStore.formatCoordinates(searchResult.mapx, 3) ?? ""
                                        postCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                                        print("위도값: \(postCoordinator.coord.lat), 경도값: \(postCoordinator.coord.lng)")
                                        print("지정장소 클릭")
                                        clickLocation.toggle()
                                    }
                                } label: {
                                    Text("\(searchResult.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                        .font(.pretendardRegular16)
                                }
                                .sheet(isPresented: $clickLocation) {
                                    LocationDetailView(searchResult: $searchResult)
                                        .presentationDetents([.height(.screenHeight * 0.6), .large])
                                }
                                if (!searchResult.address.isEmpty) {
                                    Text(searchResult.address)
                                        .font(.pretendardRegular10)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                            
                        Spacer()
                        Button {
                            searchResult.title = ""
                            searchResult.address = ""
                            searchResult.roadAddress = ""
                            postCoordinator.newMarkerTitle = ""
                        } label: {
                            Label("", systemImage: "xmark")
                                .font(.pretendardMedium16)
                                .foregroundStyle(.primary)
                                .padding(.trailing, 5)
                        }
//                            if !postCoordinator.newMarkerTitle.isEmpty {
//                                Text("신규장소: \(postCoordinator.newMarkerTitle)")
//                            }
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    //MARK: 사진
                    HStack {
                        Label("사진", systemImage: "camera")
                            .font(.pretendardMedium18)
                            .foregroundStyle(Color.privateColor)
                        Spacer()
                        Button {
                            isImagePickerPresented.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                                .font(.pretendardMedium16)
                                .foregroundStyle(.primary)
                                .padding(.trailing, 5)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePickerView(selectedImages: $selectedImage)
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
                                                    .font(.pretendardMedium20)
                                                    .foregroundColor(Color.white)
                                                    .padding(8)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                }
                            } else {
                                Text("최소 1장의 사진이 필요합니다!")
                                    .font(.pretendardRegular12)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical, 10)
                    
                    //MARK: 카테고리
                    
                    HStack {
                        Text("카테고리")
                            .font(.pretendardMedium18)
                            .foregroundStyle(Color.privateColor)
                            .padding(.leading, 5)
                        Text("(최대 3개)")
                            .font(.pretendardRegular12)
                            .foregroundColor(.secondary)
                    }
                    
                    LazyVGrid(columns: createGridColumns(), spacing: 20) {
                        ForEach (filteredCategories.indices, id: \.self) { index in
                            VStack {
                                if selectedToggle[index] {
                                    Text(MyCategory.allCases[index].categoryName)
                                        .font(.pretendardMedium16)
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 30)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 4)
                                        .background(Color.privateColor)
                                        .cornerRadius(7)
                                } else {
                                    Text(MyCategory.allCases[index].categoryName)
                                        .font(.pretendardMedium16)
                                        .foregroundColor(.primary)
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
                                toggleCategorySelection(at: index)
                                print("선택한 카테고리: \(myselectedCategory), 선택 된 Index토글: \(selectedToggle)")
                            }
                        }
                    }
                    .padding(.trailing, 8)
                    
                    //MARK: 업로드
                    Text("업로드")
                        .font(.pretendardBold18)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == "") ? .white : .black)
                        .background(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == "") ? Color.darkGrayColor : Color.privateColor)
                        .cornerRadius(7)
                        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 13))
                        .onTapGesture {
                            isshowAlert = true
                            print("신규마커최종위치: \(newMarkerlat), \(newMarkerlng)")
                        }
                    
                        .disabled(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == ""))
                    
                } // leading VStack
                
            }
            //            .sheet(isPresented: $ImageViewPresented) {
            //                ImagePickerView(selectedImages: $selectedImage)
            //            }
            // toolbar 자리
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        feedStore.isPostViewPresented = false
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
                let firstButton = Alert.Button.destructive(Text("취소")) {
                    print("취소 버튼 클릭")
                }
                let secondButton = Alert.Button.default(Text("완료")) {
                    print("registrationAlert 마지막상태: \(registrationAlert)")

                    if postCoordinator.newMarkerTitle.isEmpty {
                        creatFeed()
                    } else {
                        creatMarkerFeed()
                    }
                    feedStore.uploadToast = true
                    searchResult.title = ""
                    searchResult.address = ""
                    searchResult.roadAddress = ""
                    postCoordinator.newMarkerTitle = ""
                    registrationAlert = false
                    feedStore.isPostViewPresented = false
                    selection = 1
                    print("완료 버튼 클릭")
                    print("registrationAlert 마지막상태: \(registrationAlert)")
                }
                return Alert(title: Text("게시물 작성"),
                             message: Text("작성을 완료하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            
            .padding(.leading, 12)
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
        } // navigationStack
        .alert(isPresented: $categoryAlert) {
            Alert(
                title: Text("선택 초과"),
                message: Text("최대 3개까지 선택 가능합니다."),
                dismissButton: .default(Text("확인"))
            )
        }
//        .popup(isPresented: $feedStore.uploadToast) {
//            ToastMessageView(message: "업로드가 완료되었습니다!")
//                .onDisappear {
//                    feedStore.uploadToast = false
//                }
//        } customize: {
//            $0
//                .autohideIn(1)
//                .type(.floater(verticalPadding: 20))
//                .position(.bottom)
//                .animation(.spring())
//                .closeOnTapOutside(true)
//                .backgroundColor(.clear)
//        }
    } // body
    
    //MARK: 파베함수
    
    /// 일반적인 업로드 함수
    func creatFeed() {
        //        let selectCategory = chipsViewModel.chipArray.filter { $0.isSelected }.map { $0.titleKey }
        
        var feed = MyFeed(writerNickname: userStore.user.nickname,
                          writerName: userStore.user.name,
                          writerProfileImage: userStore.user.profileImageURL,
                          images: images,
                          contents: text,
                          createdAt: createdAt,
                          title: searchResult.title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""),
                          category: myselectedCategory,
                          address: searchResult.address,
                          roadAddress: searchResult.roadAddress,
                          mapx: searchResult.mapx,
                          mapy: searchResult.mapy
        )
        
        if let selectedImages = selectedImage {
            var imageUrls: [String] = []
            
            for image in selectedImages {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }
                
                let storageRef = storage.reference().child(UUID().uuidString) //
                
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let imageUrl = url?.absoluteString else { return }
                        imageUrls.append(imageUrl)
                        
                        if imageUrls.count == selectedImages.count {
                            
                            feed.images = imageUrls
                            
                            do {
                                try db.collection("User").document(userStore.user.email).collection("MyFeed").document(feed.id) .setData(from: feed)
                            } catch {
                                print("Error saving feed: \(error)")
                            }
                            do {
                                try db.collection("Feed").document(feed.id).setData(from: feed)
                            } catch {
                                print("Error saving feed: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    /// 새로운 장소와 마커를 함께 저장할 때 쓰여지는 함수
    func creatMarkerFeed() {
        //        let selectCategory = chipsViewModel.chipArray.filter { $0.isSelected }.map { $0.titleKey }
        
        var feed = MyFeed(writerNickname: userStore.user.nickname,
                          writerName: userStore.user.name,
                          writerProfileImage: userStore.user.profileImageURL,
                          images: images,
                          contents: text,
                          createdAt: createdAt,
                          title: postCoordinator.newMarkerTitle,
                          category: myselectedCategory,
                          address: searchResult.address,
                          roadAddress: searchResult.roadAddress,
                          mapx: newMarkerlng,
                          mapy: newMarkerlat
        )
        
        if let selectedImages = selectedImage {
            var imageUrls: [String] = []
            
            for image in selectedImages {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }
                
                let storageRef = storage.reference().child(UUID().uuidString) //
                
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let imageUrl = url?.absoluteString else { return }
                        imageUrls.append(imageUrl)
                        
                        if imageUrls.count == selectedImages.count {
                            
                            feed.images = imageUrls
                            
                            do {
                                try db.collection("User").document(userStore.user.email).collection("MyFeed").document(feed.id) .setData(from: feed)
                            } catch {
                                print("Error saving feed: \(error)")
                            }
                            do {
                                try db.collection("Feed").document(feed.id).setData(from: feed)
                            } catch {
                                print("Error saving feed: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }

    func toggleCategorySelection(at index: Int) {
        selectedToggle[index].toggle()
        let categoryName = MyCategory.allCases[index].categoryName

        if selectedToggle[index] {
            if myselectedCategory.count < maxSelectedCategories {
                myselectedCategory.append(categoryName)
            } else {
                categoryAlert = true
                myselectedCategory = []
                selectedToggle = Array(repeating: false, count: MyCategory.allCases.count)
            }
        } else if let selectedIndex = myselectedCategory.firstIndex(of: categoryName) {
            myselectedCategory.remove(at: selectedIndex)
        }
    }
    
    func createGridColumns() -> [GridItem] {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
        return columns
    }
    
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(root: .constant(true), selection: .constant(3), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
    }
}


