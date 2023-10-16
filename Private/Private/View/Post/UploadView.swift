//
//  UploadView.swift
//  Private
//
//  Created by 최세근 on 10/10/23.
//

import SwiftUI

struct UploadView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isImagePickerPresented: Bool
    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: [UIImage]? = []
    @State private var isPostViewPresented: Bool = false /// PostView
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    
    var body: some View {
        NavigationStack {
 
        }
        .onAppear {
            isPostViewPresented = true
            print("업로드 뷰 올라옴")
        }
        .fullScreenCover(isPresented: $isPostViewPresented) {
            PostView(root: $root, selection: $selection, isPostViewPresented: $isPostViewPresented)
//                .onDisappear {
//                    selection = 1
//                    print("홈뷰로 이동")
//                }
        }
    }
}
struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(root: .constant(true), selection: .constant(3), isImagePickerPresented: .constant(true), showLocation: .constant(true), searchResult: .constant(SearchResult(title: "", category: "", address: "", roadAddress: "", mapx: "", mapy: "")))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())

    }
}
