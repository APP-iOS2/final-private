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
    @State var isFeed: Bool = true
    @State var isMap: Bool = false
    @State var isReservation: Bool = false
    @State var isMyPageFeedSheet: Bool = false 
    @State var selctedFeed : MyFeed = MyFeed()
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button {
                    isFeed = true
                    isMap = false
                    isReservation = false
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
                    isReservation = false
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
                                        isReservation = false
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
                Button {
                    isFeed = false
                    isMap = false
                    isReservation = true
                } label: {
                    Image(systemName: "calendar.badge.clock")
                    Text("예약 내역")
                }
                .font(.pretendardBold18)
                .foregroundColor(isReservation ? .primary : .primary.opacity(0.3))
                Spacer()
            }
            //.padding(.top,.screenHeight * 0.02)
            if (isFeed == true) {
                ScrollView {
                    if userStore.myFeedList.isEmpty {
                        Text("게시물이 존재 하지 않습니다.")
                            .font(.pretendardBold24)
                            .padding(.top, .screenHeight * 0.2)
                    } else {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 1
                        ) {
                            ForEach(userStore.myFeedList, id: \.self) { feed in
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
                                    MyPageFeedView(isMyPageFeedSheet: $isMyPageFeedSheet, feed: selctedFeed, feedList: userStore.myFeedList)
                                        .presentationDetents([.height(.screenHeight * 0.7)])
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
