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
    @State var isFeed: Bool = true
    @State var isMap: Bool = false
    @State var isReservation: Bool = false
    var columns: [GridItem] = [GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil),
                               GridItem(.fixed(.screenWidth*0.95*0.3), spacing: 1, alignment:  nil)]
    let user: User
    
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
            if (isFeed == true) {
                ScrollView {
                if user.myFeed.isEmpty {
                    Text("게시물이 존재 하지 않습니다.")
                        .font(.pretendardBold24)
                        .padding(.top, .screenHeight * 0.2)
                } else {
                        LazyVGrid(
                            columns: columns,
                            alignment: .center,
                            spacing: 1
                        ) {
                            ForEach(user.myFeed, id: \.self) { feed in
                                KFImage(URL(string:feed.images[0])) .placeholder {
                                    Image(systemName: "photo")
                                }.resizable()
                                    .frame(width: .screenWidth*0.95*0.3 ,height: .screenWidth*0.95*0.3)
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
                        MyReservation( isShowingMyReservation: .constant(true))
                    }
                }
            }
        }
    }
}

struct OtherHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OtherHistoryView(user: User())
    }
}
