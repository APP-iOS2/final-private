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
    @Binding var isPostViewPresented: Bool /// PostView

    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: [UIImage]? = []
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    
    var body: some View {
        NavigationStack {
            Button {
                isImagePickerPresented.toggle()
            } label: {
                Label("", systemImage: "plus")
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerView(selectedImages: $selectedImage)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(root: .constant(true), selection: .constant(3), isImagePickerPresented: .constant(true), isPostViewPresented: .constant(true))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())

    }
}
