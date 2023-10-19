//
//  MyHistoryView.swift
//  Private
//
//  Created by 주진형 on 2023/09/25.
//

import SwiftUI
import Kingfisher

struct MyHistoryView: View {
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var reservationStore: ReservationStore
    @EnvironmentObject private var feedStore: FeedStore
    @State var isFeed: Bool = true
    @State var isMap: Bool = false
    @State var isReservation: Bool = false
    @State var isMyPageFeedSheet: Bool = false 
    //@State var selctedFeed : MyFeed = MyFeed()
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.33), spacing: 1, alignment:  nil)]
    var body: some View {
        VStack{
            if (isFeed == true) {
                ScrollView {
                    if userStore.myFeedList.isEmpty {
                        Text("게시물이 존재 하지 않습니다.")
                            .font(.pretendardBold24)
                            .foregroundColor(.white)
                            .padding(.top, .screenHeight * 0.2 + 37.2)
                    } else {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 1
                        ) {
                            ForEach(userStore.myFeedList, id: \.self) { feed in
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
                                    MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, feed: feedStore.selctedFeed, feedList: userStore.myFeedList)
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

struct MyHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MyHistoryView().environmentObject(UserStore())
    }
}
