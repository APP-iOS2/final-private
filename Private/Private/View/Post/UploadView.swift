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
    @Binding var isPostViewPresented: Bool /// PostView
    
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: [UIImage]? = []
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    
    var body: some View {
        NavigationStack {
            
        }
        .fullScreenCover(isPresented: $isPostViewPresented) {
            PostView(root: .constant(true), selection: .constant(3))
        }
    }
}
struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(root: .constant(true), selection: .constant(3), isImagePickerPresented: .constant(true), isPostViewPresented: .constant(true))
            .environmentObject(FeedStore())
            .environmentObject(UserStore())

    }
}
