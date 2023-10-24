
//
//  FeedUpdateView.swift
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

struct FeedUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    //    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var feedStore: FeedStore
    @EnvironmentObject var userStore: UserStore
    //    @EnvironmentObject var userDataStore: UserStore
    @State var newFeed : MyFeed = MyFeed()
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    @StateObject private var postStore: PostStore = PostStore()
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isFeedUpdateViewPresented: Bool /// FeedUpdateView
    @Binding var searchResult: SearchResult
    @State private var text: String = "" /// 텍스트마스터 내용
    @State private var textPlaceHolder: String = "수정하실 내용을 적어주세요" /// 텍스트마스터 placeholder
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
    
    @State var feed: MyFeed
    //    @State var category : Category
    private let minLine: Int = 10
    private let maxLine: Int = 12
    private let fontSize: Double = 18
    private let maxSelectedCategories = 3
    let userDataStore: UserStore = UserStore()
    var db = Firestore.firestore()
    var storage = Storage.storage()
    //@State private var selectedCategories: Set<MyCategory> = []
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
                                .font(.pretendardMedium16)
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
                                    .font(.pretendardRegular12)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, 5)
                            } else {
                                Button {
                                    if !postCoordinator.newMarkerTitle.isEmpty {
                                        clickLocation.toggle()
                                        postCoordinator.newLocalmoveCameraPosition()
                                        //                                        postCoordinator.makeNewLocationMarker()
                                        postCoordinator.makeSearchLocationMarker()
                                    } else {
                                        lat = locationSearchStore.formatCoordinates(searchResult.mapy, 2) ?? ""
                                        lng = locationSearchStore.formatCoordinates(searchResult.mapx, 3) ?? ""
                                        
                                        postCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                                        postCoordinator.newMarkerTitle = searchResult.title
                                        print("위도값: \(postCoordinator.coord.lat), 경도값: \(postCoordinator.coord.lng)")
                                        print("지정장소 클릭")
                                        clickLocation.toggle()
                                        postCoordinator.moveCameraPosition()
                                        postCoordinator.makeSearchLocationMarker()
                                    }
                                } label: {
                                    Text("\(searchResult.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                                        .font(.pretendardRegular12)
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
                                .foregroundStyle(Color.privateColor)
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
                            .font(.pretendardMedium16)
                            .foregroundStyle(Color.privateColor)
                        Spacer()
                        Button {
                            isImagePickerPresented.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                                .font(.pretendardMedium16)
                                .foregroundStyle(Color.privateColor)
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
                            .font(.pretendardMedium20)
                            .foregroundStyle(Color.privateColor)
                        Text("(최대 3개)")
                            .font(.pretendardRegular12)
                            .foregroundColor(.secondary)
                        //Text()
                    }
                    LazyVGrid(columns: createGridColumns(), spacing: 20) {
                        ForEach (filteredCategories.indices, id: \.self) { index in
                            VStack {
                                if selectedToggle[index] {
                                    Text(MyCategory.allCases[index].categoryName)
                                        .font(.pretendardMedium16)
                                        .foregroundColor(.primary)
                                        .frame(width: 70, height: 30)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 4)
                                        .background(Color.privateColor)
                                        .cornerRadius(7)
                                } else {
                                    Text(MyCategory.allCases[index].categoryName)
                                        .font(.pretendardMedium16)
                                        .foregroundColor(.white)
                                        .background(Color.black)
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
                    Text("수정 완료")
                        .font(.pretendardBold18)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == "") ? .white : .black)
                        .background(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == "") ? Color.darkGrayColor : Color.privateColor)
                        .cornerRadius(7)
                        .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 13))
                        .onTapGesture {
                            isshowAlert = true
                            
                            print("신규마커최종위치: \(newMarkerlat), \(newMarkerlng)")
                            //
                        }
                        .disabled(text == "" || selectedImage == [] || myselectedCategory == [] || (searchResult.title == "" && postCoordinator.newMarkerTitle == ""))
                }
            }
            
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
                let firstButton = Alert.Button.cancel(Text("취소")) {
                    print("취소 버튼 클릭")
                }
                let secondButton = Alert.Button.default(Text("완료")) {
                    print("registrationAlert 마지막상태: \(registrationAlert)")
                    self.feedStore.updatedToast = true
                    // 업데이트 피드가 있으면
                    //MARK: 이부분 주석..
                    //                    if postCoordinator.newMarkerTitle.isEmpty {
                    //                        creatFeed()
                    //                    } else {
                    //                        creatMarkerFeed()
                    //                    }
                    //MARK: 업데이트 피드 함수를
                    let newFeed = MyFeed(id: feed.id, writerNickname: feed.writerNickname, writerName: feed.writerName, writerProfileImage: feed.writerProfileImage, images: images, contents: text, createdAt: feed.createdAt, title: searchResult.title, category: myselectedCategory, address: searchResult.address, roadAddress: searchResult.roadAddress, mapx: searchResult.mapx, mapy: searchResult.mapy)
     
                    updateFeed(inputFeed: newFeed, feedId: feed.id)
                    searchResult.title = ""
                    searchResult.address = ""
                    searchResult.roadAddress = ""
                    postCoordinator.newMarkerTitle = ""
                    
                    registrationAlert = false
                    
                    isFeedUpdateViewPresented = false
                    selection = 1
                    print("완료 버튼 클릭")
                    print("registrationAlert 마지막상태: \(registrationAlert)")
                }
                return Alert(title: Text("피드 수정"),
                             message: Text("수정을 완료하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            .padding(.leading, 12)
            .navigationTitle("피드 수정")
            .navigationBarTitleDisplayMode(.inline)
        } // navigationStack
        .alert(isPresented: $categoryAlert) {
            Alert(
                title: Text("선택 초과"),
                message: Text("최대 3개까지 선택 가능합니다."),
                dismissButton: .default(Text("확인"))
            )
        }
    } // body
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
    
    // MARK: Feed 객체를 뉴 피드에 넣은 이미지로 수정
    func modifyUpdateFeed(with selectedImages: [String]) -> [String] {
        return selectedImages
    }
    func updateFeed(inputFeed: MyFeed, feedId: String) {
        print("Function: \(#function) started")
        
        // inputFeed의 복사본 생성
        var feedCopy = inputFeed
        
        if let selectedImages = selectedImage {
            var imageUrls: [String] = []
            let group = DispatchGroup()  // DispatchGroup 생성
            
            for image in selectedImages {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { continue }
                
                let storageRef = storage.reference().child(UUID().uuidString)
                
                group.enter() // DispatchGroup 시작
                storageRef.putData(imageData) { _, error in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        group.leave()  // Error 발생 시 DispatchGroup 종료
                        return
                    }
                    
                    storageRef.downloadURL { url, error in
                        guard let imageUrl = url?.absoluteString else {
                            group.leave()  // Error 발생 시 DispatchGroup 종료
                            return
                        }
                        imageUrls.append(imageUrl)
                        group.leave()  // 이미지 URL 획득 후 DispatchGroup 종료
                    }
                }
            }
            
            // 모든 이미지 업로드가 완료되면
            group.notify(queue: .main) {
                let updatedImages = self.modifyUpdateFeed(with: imageUrls)
                feedCopy.images = updatedImages
                
                feedCollection.document(feedId).updateData([

                                "writerNickname": userStore.user.nickname,
                                "writerName": userStore.user.id,
                                "writerProfileImage": userStore.user.profileImageURL,
                                "images": feedCopy.images,
                                "contents": inputFeed.contents,
                                "createdAt": inputFeed.createdAt,
                                "title": inputFeed.title,
                                "category": inputFeed.category,
                                "address": inputFeed.address,
                                "roadAddress": inputFeed.roadAddress,
                                "mapx": inputFeed.mapx,
                                "mapy": inputFeed.mapy
                            ]) { error in
                                if let error = error {
                                    print("Error updating feed: \(error.localizedDescription)")
                                } else {
                                    print("Feed updated successfully")
                                    feedStore.fetchFeeds()
                                    
                                }
                            }
                userCollection.document(userStore.user.email).collection("MyFeed").document(feedId).updateData([
                    "writerNickname": userStore.user.nickname,
                    "writerName": userStore.user.id,
                    "writerProfileImage": userStore.user.profileImageURL,
                    "images": feedCopy.images,
                    "contents": inputFeed.contents,
                    "createdAt": inputFeed.createdAt,
                    "title": inputFeed.title,
                    "category": inputFeed.category,
                    "address": inputFeed.address,
                    "roadAddress": inputFeed.roadAddress,
                    "mapx": inputFeed.mapx,
                    "mapy": inputFeed.mapy
                ]) { error in
                    if let error = error {
                        print("Error updating feed: \(error.localizedDescription)")
                    } else {
                        print("Feed updated successfully")
                        feedStore.fetchFeeds()
                        
                    }
                }
                        }
                    }
                }
            }

