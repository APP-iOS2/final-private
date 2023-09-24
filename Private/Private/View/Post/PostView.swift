//
//  PostView.swift
//  Private
//
//  Created by 변상우 on 2023/09/21.
//

import SwiftUI

struct PostView: View {
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    @EnvironmentObject private var feedStore: FeedStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var text: String = ""
    @FocusState private var isTextMasterFocused: Bool
    
    private let minLine: Int = 5
    private let maxLine: Int = 8
    private let fontSize: Double = 24
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    AsyncImage(url: URL(string: UserStore.user.profileImageURL)) { image in
                        image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 70, height: 70)
                        
                        VStack {
                            Text(UserStore.user.name)
                            Text(UserStore.user.nickname)
                        }
                    } // HStack
                    .padding(.trailing, 250)
                
                
                TextMaster(text: $text, isFocused: $isTextMasterFocused, maxLine: minLine, fontSize: fontSize)
                    .listRowSeparator(.hidden)
                
                Divider()
                CatecoryView()
                
            } // ScrollView
            .navigationTitle("글쓰기")
            .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(root: .constant(true), selection: .constant(3))
    }
}
