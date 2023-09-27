//
//  PictureView.swift
//  Private
//
//  Created by 최세근 on 2023/09/26.
//

import SwiftUI

struct PictureView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isImagePickerPresented: Bool

    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImage: [UIImage]? = []
    
    @EnvironmentObject private var feedStore: FeedStore


    
    var body: some View {
        NavigationStack {
            VStack {
//                NavigationLink {
//                    PostView(root: $root, selection: $selection)
//                } label: {
//                    Text("dd")
//                }
            }
            .fullScreenCover(isPresented: $isImagePickerPresented) {
                ImagePickerView(selectedImages: $selectedImage)
            }
            .navigationTitle("사진 선택")
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(root: .constant(true), selection: .constant(3), isImagePickerPresented: .constant(true))
            .environmentObject(FeedStore())
    }
}
