//
//  OtherSavedView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI
import Kingfisher

struct OtherSavedView: View {
    @State var isMyPageFeedSheet: Bool = false
    @State var selctedFeed : MyFeed = MyFeed()
    let user: User
    let otherSavedFeedList: [MyFeed]
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    
    var body: some View {
        ScrollView {
            if otherSavedFeedList.isEmpty {
                Text("저장한 피드가 없습니다")
                    .font(.pretendardBold24)
                    .padding(.top, .screenHeight * 0.2)
            } else {
                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: 1
                ) {
                    ForEach(otherSavedFeedList, id: \.self) { feed in
                        AsyncImage(url:URL(string:feed.images[0])) { image in
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
                                MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, feed: selctedFeed, feedList: otherSavedFeedList)
                                    .presentationDetents([.height(.screenHeight * 0.7)])
                            }
                        }
                    }
                }
            }
        }
    }
}

struct OtherSavedView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSavedView(user: User(), otherSavedFeedList: [MyFeed()])
    }
}

