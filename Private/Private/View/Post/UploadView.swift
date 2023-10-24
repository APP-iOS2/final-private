//
//  UploadView.swift
//  Private
//
//  Created by 최세근 on 10/10/23.
//

import SwiftUI
import NMapsMap

struct UploadView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var userDataStore: UserStore
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared

    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isImagePickerPresented: Bool
    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult
    
    @State private var selectedImage: [UIImage]? = []

    var body: some View {
        NavigationStack {
            
        }
        .onAppear {
            feedStore.isPostViewPresented = true
            searchResult.title = ""
            searchResult.roadAddress = ""
            postCoordinator.newMarkerTitle = ""
            print("업로드 뷰 올라옴")
        }
        .fullScreenCover(isPresented: $feedStore.isPostViewPresented) {
            PostView(root: $root, selection: $selection, searchResult: $searchResult)
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
