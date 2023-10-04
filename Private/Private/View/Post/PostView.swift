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

struct PostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    @StateObject private var postStore: PostStore = PostStore()
    
    @State private var selectedWriter: String = "김아무개"
    
    @State private var writer: String = ""
    @State private var images: [String] = []
    @State private var createdAt: Double = Date().timeIntervalSince1970
    @State private var visitedShop: String = ""

    @State private var text: String = ""
    @State private var clickLocation: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var ImageViewPresented: Bool = true
    @State private var feedId: String = ""
    @State private var showLocation: Bool = false

    
    @State private var selectedImage: [UIImage]?
    @FocusState private var isTextMasterFocused: Bool
    
    private let minLine: Int = 7
    private let maxLine: Int = 8
    private let fontSize: Double = 24
    
    @State var selectedCategory: [String] = []
    @State var myselectedCategory: [MyCategory] = [.koreanFood, .brunch]
    
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
//                    ForEach(feedStore.feedList) { feed in
//                        HStack {
//                            Circle()
//                                .frame(width: .screenWidth*0.23)
//                            Image(systemName: "person")
//                                .resizable()
//                                .frame(width: .screenWidth*0.23,height: 80)
//                                .foregroundColor(.gray)
//                                .clipShape(Circle())
//
//
//                            VStack(alignment: .leading, spacing: 5) {
//                                Text(userStore.user.name)
//                                Text(userStore.user.nickname)
//                            }
//                        } // HStack
//                    } // foreach
                    
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
                        .padding(.trailing, 10)
                    
                    //MARK: 장소
                    VStack {
                        Button {
                            showLocation = true
                        } label: {
                            Label("장소", systemImage: "location")
                        }
                        .sheet(isPresented: $showLocation){
                            NavigationStack {
                                MapMainView()
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            Button {
                                                showLocation = false
                                            } label: {
                                                Text("취소")
                                            }
                                        }
                                    }
                                    .font(.pretendardBold18)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                
                    if clickLocation {
                        Text("해당 장소")
                            .font(.body)
                        // 맵 관련 로직
                            
                    } else {
                        Text("장소를 선택해주세요")
                            .font(.body)
                            .foregroundColor(.secondary)
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
                            if let images = selectedImage {
                                ForEach(images, id: \.self) { image in
                                    ZStack {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(Rectangle())
                                        //                                    Button {
                                        //                                        feedStore.removeImage(imageList)
                                        //                                    } label: {
                                        //                                        Image(systemName: "x.circle")
                                        //                                            .foregroundColor(.black)
                                        //                                    }
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical, 10)

                    //MARK: 카테고리
                    CatecoryView(selectedCategory: $selectedCategory)
                } // leading VStack
            }
            .fullScreenCover(isPresented: $ImageViewPresented) {
                ImagePickerView(selectedImages: $selectedImage)
            }
            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarLeading) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Text("취소")
//                            .foregroundStyle(.white)
//                    }
//                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        fetch()
//                        dismiss()
                    } label: {
                        Text("완료")
                    }
                }
            }
            .padding(.leading, 12)
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func fetch() {
//        let selectCategory = chipsViewModel.chipArray.filter { $0.isSelected }.map { $0.titleKey }
        var feed = MyFeed(writer: writer, images: images, contents: text, createdAt: createdAt, visitedShop: visitedShop, category: selectedCategory)
        
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
                                try db.collection("User").document(feed.id).setData(from: feed)
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

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(root: .constant(true), selection: .constant(3))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())
    }
}


