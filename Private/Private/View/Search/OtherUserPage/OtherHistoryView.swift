//
//  OtherHistoryView.swift
//  Private
//
//  Created by 박범수 on 10/5/23.
//

import SwiftUI
import Kingfisher

struct OtherHistoryView: View {

    @EnvironmentObject private var reservationStore: ReservationStore
    @EnvironmentObject private var userStore: UserStore
    @State private var isFeed: Bool = true
    @State private var isMap: Bool = false
    @State private var isReservation: Bool = false
    @State private var isMyPageFeedSheet: Bool = false
    @State private var selctedFeed : MyFeed = MyFeed()
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    let user: User
    let otherFeedList: [MyFeed]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button {
                    isFeed = true
                    isMap = false
                } label: {
                    Image(systemName: "line.3.horizontal")
                    Text("피드")
                }
                .font(.pretendardBold18)
                .foregroundColor(isFeed ? .primary : .primary.opacity(0.3))
                Spacer()
                Button {
                    isFeed = false
                    isMap = true
                } label: {
                    Image(systemName: "map")
                    Text("지도")
                }
                .font(.pretendardBold18)
                .foregroundColor(isMap ? .primary : .primary.opacity(0.3))
                .sheet(isPresented: $isMap){
                    NavigationStack {
                        MapMainView()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        isMap = false
                                        isFeed = true
                                    } label: {
                                        Text("취소")
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .font(.pretendardBold18)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
                Spacer()
            }
            if (isFeed == true) {
                ScrollView {
                if otherFeedList.isEmpty {
                    Text("게시물이 존재 하지 않습니다.")
                        .font(.pretendardBold24)
                        .padding(.top, .screenHeight * 0.2)
                } else {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 1
                        ) {
                            ForEach(otherFeedList, id: \.self) { feed in
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
                                    MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, feed: selctedFeed, feedList: otherFeedList)
                                        .presentationDetents([.height(.screenHeight * 0.7)])
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct OtherHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OtherHistoryView(user: User(), otherFeedList: [MyFeed()])
    }
}
