//
//  MySavedView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI
import Kingfisher

struct MySavedView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @State var isMyPageFeedSheet: Bool = false
    @State var selctedFeed : MyFeed = MyFeed()
    @State private var isLongPressing = false
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    var body: some View {
        ScrollView {
            if userStore.mySavedFeedList.isEmpty {
                Text("저장한 피드가 없습니다")
                    .font(.pretendardBold24)
                    .padding(.top, .screenHeight * 0.2 + 37.2)
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 1
                ) {
                    ForEach(userStore.mySavedFeedList, id: \.self) { feed in
                        Button {
                            selctedFeed = feed
                            isMyPageFeedSheet = true
                        } label: {
                            KFImage(URL(string:feed.images[0])) .placeholder {
                                Image(systemName: "photo")
                            }.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: .screenWidth*0.95*0.3 ,height: .screenWidth*0.95*0.3)
                                .clipShape(Rectangle())
                        }
                        .sheet(isPresented: $isMyPageFeedSheet){
                            MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, feed: selctedFeed)
                                .presentationDetents([.height(.screenHeight * 0.7)])
                        }
                        .gesture(
                            LongPressGesture()
                                .onChanged { _ in
                                    isLongPressing = true
                                }
                        )
                        .contextMenu(ContextMenu(menuItems: {
                            Button("선택한 피드 삭제") {
                                userStore.deleteFeed(feed)
                                userStore.user.myFeed.removeAll { $0 == feed.images[0] }
                                userStore.updateUser(user: userStore.user)
                            }
                        }))
                    }
                }
            }
        }
    }
}

struct MySavedView_Previews: PreviewProvider {
    static var previews: some View {
        MySavedView().environmentObject(UserStore())
    }
}
