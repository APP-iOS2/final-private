//
//  OtherSavedView.swift
//  Private
//
//  Created by 박범수 on 10/22/23.
//

import SwiftUI
import Kingfisher

struct OtherSavedView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @State var isMyPageFeedSheet: Bool = false
    @State var selctedFeed : MyFeed = MyFeed()
    @State private var isLongPressing = false
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil)]
    let user:User
    
    var body: some View {
        ScrollView {
            if userStore.otherSavedFeedList.isEmpty {
                Text("저장한 피드가 없습니다")
                    .font(.pretendardBold24)
                    .foregroundColor(.primary)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 1
                ) {
                    ForEach(userStore.otherSavedFeedList, id: \.self) { feed in
                        Button {
                            selctedFeed = feed
                            isMyPageFeedSheet = true
                        } label: {
                            KFImage(URL(string:feed.images[0])) .placeholder {
                                Image(systemName: "photo")
                            }.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: .screenWidth * 0.33, height: .screenWidth * 0.33)
                                .clipShape(Rectangle())
                        }
                        .sheet(isPresented: $isMyPageFeedSheet){
                            MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, root:$root, selection:$selection, feed: selctedFeed, feedList: userStore.otherSavedFeedList, isMyFeedList: false)
                                .presentationDetents([.height(.screenHeight * 0.7)])
                        }
                        .gesture(
                            LongPressGesture()
                                .onChanged { _ in
                                    isLongPressing = true
                                }
                        )
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
