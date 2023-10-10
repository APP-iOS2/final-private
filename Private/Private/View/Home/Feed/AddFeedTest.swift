//
//  AddFeedTest.swift
//  Private
//
//  Created by yeon on 10/10/23.
//

import SwiftUI
import NMapsMap
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore
import Combine

struct AddFeedTest: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    @StateObject private var postStore: PostStore = PostStore()
    
    @State private var selectedWriter: String = "김아무개"
    @State private var text: String = ""
    @State private var writer: String = ""
    @State private var images: [String] = []
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var visitedShop: String = ""
    @State private var feedId: String = ""

    @State private var clickLocation: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var ImageViewPresented: Bool = true
    @State private var showLocation: Bool = false
    @State private var isshowAlert = false
    
    @State private var selectedImage: [UIImage]?
    @FocusState private var isTextMasterFocused: Bool
    
    @State private var searchResult: SearchResult = SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")
    
    private let minLine: Int = 7
    private let maxLine: Int = 8
    private let fontSize: Double = 24
    
    @State var selectedCategory: [String] = []
    @State private var myselectedCategory: [MyCategory] = []
    @State private var selectedToggle: [Bool] = Array(repeating: false, count: MyCategory.allCases.count)
    
    var db = Firestore.firestore()
    var storage = Storage.storage()
    //    var categoryString: [String] {
    //        selectedCategory.map { $0.rawValue }
    //    }
//    let resultString = categoryString.joined(separator: ",")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: .screenWidth*0.19)
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: .screenWidth*0.19, height: 65)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(userStore.user.name)
                            Text("@\(userStore.user.nickname)")
                        }
                    }
                    .padding(.vertical, 10)

                    //MARK: 내용
                    TextMaster(text: $text, isFocused: $isTextMasterFocused, maxLine: minLine, fontSize: fontSize)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        .padding(.trailing, 10)
                    
                    //MARK: 장소
                    VStack {
                        Button {
                            showLocation = true
                        } label: {
                            Label("장소", systemImage: "location")
                        }
                        .sheet(isPresented: $showLocation){
                            LocationSearchView(showLocation: $showLocation, searchResult: $searchResult)
//                            NavigationStack {
//                                MapMainView()
//                                    .toolbar {
//                                        ToolbarItem(placement: .navigationBarLeading) {
//                                            Button {
//                                                showLocation = false
//                                            } label: {
//                                                Text("취소")
//                                            }
//                                        }
//                                    }
//                                    .font(.pretendardBold18)
//                            }
                        }
                    }
                    .padding(.vertical, 10)
                
                    if searchResult.title.isEmpty {
                        Text("장소를 선택해주세요")
                            .font(.body)
                            .foregroundColor(.secondary)
                    } else {
                        Text("\(searchResult.title)".replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: ""))
                            .font(.body)
                    }
                    Divider()
                        .padding(.vertical, 10)

                    //MARK: 사진
                    HStack {
                        Label("사진", systemImage: "camera")
                        Text("(최대 10장)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button {
                            isImagePickerPresented.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePickerView(selectedImages: $selectedImage)
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
                    CatecoryView(selectedCategory: $selectedCategory)
                        .padding(.trailing, 8)
                } // leading VStack
            }
            .fullScreenCover(isPresented: $ImageViewPresented) {
                ImagePickerView(selectedImages: $selectedImage)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isshowAlert = true
                    } label: {
                        Text("완료")
                    }
                }
            }
            .alert(isPresented: $isshowAlert) {
                let firstButton = Alert.Button.cancel(Text("취소")) {
                    print("primary button pressed")
                }
                let secondButton = Alert.Button.default(Text("완료")) {
                    fetch()
                    print("secondary button pressed")
                }
                return Alert(title: Text("게시물 작성"),
                             message: Text("작성을 완료하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            .padding(.leading, 12)
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
        } // navigationStack
    } // body
    
    //MARK: 파베함수
    func fetch() {
        //        let selectCategory = chipsViewModel.chipArray.filter { $0.isSelected }.map { $0.titleKey }
        
        var feed = MyFeed(writer: userStore.user.name,
                          images: images,
                          contents: text,
                          createdAt: createdAt,
                          visitedShop: visitedShop,
                          category: myselectedCategory)
        
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
}

struct AddFeedTest_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedTest(root: .constant(true), selection: .constant(3))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
    }
}


