//
//  OtherHistoryView.swift
//  Private
//
//  Created by 박범수 on 10/22/23.
//

import SwiftUI
import Kingfisher

struct OtherHistoryView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var reservationStore: ReservationStore
    @EnvironmentObject private var feedStore: FeedStore
    
    @State var isFeed: Bool = true
    @State var isMap: Bool = false
    @State var isReservation: Bool = false
    @State var isMyPageFeedSheet: Bool = false
    
    @Binding var root: Bool
    @Binding var selection: Int
    
    //@State var selctedFeed : MyFeed = MyFeed()
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil)]
    
    let user:User
    
    var body: some View {
        VStack{
            if (isFeed == true) {
                ScrollView {
                    if userStore.otherFeedList.isEmpty {
                        Text("게시물이 존재 하지 않습니다.")
                            .font(.pretendardBold24)
                            .foregroundColor(.primary)
                            .padding(.top, .screenHeight * 0.2 + 37.2)
                    } else {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 1
                        ) {
                            ForEach(userStore.otherFeedList, id: \.self) { feed in
                                Button {
                                    feedStore.selctedFeed = feed
                                    isMyPageFeedSheet = true
                                } label: {
                                    KFImage(URL(string:feed.images[0])) .placeholder {
                                        Image(systemName: "photo")
                                    }.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: .screenWidth*0.33,height: .screenWidth*0.33)
                                        .clipShape(Rectangle())
                                }
                                .sheet(isPresented: $isMyPageFeedSheet) {
                                    MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, root:$root, selection:$selection, feed: feedStore.selctedFeed, feedList: userStore.otherFeedList, isMyFeedList: false)
                                        .presentationDetents([.height(.screenHeight)])
                                }
                            }
                        }
                    }
                }
            }
            if (isReservation == true) {
                ScrollView {
                    if reservationStore.reservationList.isEmpty {
                        Text("예약내역이 존재하지 않습니다.")
                            .font(.pretendardBold24)
                            .foregroundColor(.primary)
                            .padding(.top, .screenHeight * 0.2)
                    } else {
                        MyReservation(isShowingMyReservation: .constant(true))
                    }
                }
                .onAppear {
                    reservationStore.fetchReservation()
                }
            }
            Spacer()
        }
    }
}
