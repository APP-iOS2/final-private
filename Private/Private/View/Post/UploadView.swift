//
//  UploadView.swift
//  Private
//
//  Created by 최세근 on 10/10/23.
//

import SwiftUI
import NMapsMap

struct UploadView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    @Binding var isImagePickerPresented: Bool
    @Binding var showLocation: Bool
    @Binding var searchResult: SearchResult

    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: [UIImage]? = []
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var userDataStore: UserStore

    var body: some View {
        NavigationStack {
            
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
        .onAppear {
            feedStore.isPostViewPresented = true
            print("업로드 뷰 올라옴")
        }
        .fullScreenCover(isPresented: $feedStore.isPostViewPresented) {
            PostView(root: $root, selection: $selection, searchResult: $searchResult)
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
