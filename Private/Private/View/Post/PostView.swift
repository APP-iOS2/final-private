//
//  PostView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    
//    let imageList: Feed
    
    @State private var text: String = ""
    @State private var clickLocation: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: [UIImage]? = []
    @FocusState private var isTextMasterFocused: Bool
    
    private let minLine: Int = 5
    private let maxLine: Int = 8
    private let fontSize: Double = 24
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(feedStore.feedList) { feed in
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: feed.writer.profileImageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            } placeholder: {
                                Image("userDefault")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(feed.writer.name)")
                                Text("\(feed.writer.nickname)")
                            }
                        } // HStack
                        
                        
                    } // 큰 VStack
                } // foreach
                //MARK: 내용
                TextMaster(text: $text, isFocused: $isTextMasterFocused, maxLine: minLine, fontSize: fontSize)
                
                //MARK: 장소
                HStack {
                    Button {
                        
                    } label: {
                        Label("장소", systemImage: "location")
                    }
                }
                
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
                
                //MARK: 사진
                HStack {
                    Label("사진", systemImage: "camera")
                    Text("(최대 10장)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action:  {
                        isImagePickerPresented.toggle()
                    }) {
                        Image(systemName: "plus")
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
                                        .frame(width: 100, height: 100)
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
                //MARK: 카테고리
                CatecoryView()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("완료")
                    }
                }
            }
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(root: .constant(true), selection: .constant(3))
            .environmentObject(FeedStore())
        
    }
}
