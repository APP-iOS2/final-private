//
//  MapFeedSheetView.swift
//  Private
//
//  Created by yeon I on 2023/09/25.
//
import SwiftUI

struct MapFeedSheetView: View {
    
    @EnvironmentObject private var userStore: UserStore
    
    let feedList: [MyFeed]
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    if (userStore.user.bookmark.contains("\(feedList[0].images[0].suffix(32))")) {
                        print("핀, 장소 저장")
                        for placeId in userStore.user.bookmark {
                            for userStorePlaceId in userStore.mySavedPlaceList {
                                if placeId == userStorePlaceId.writerProfileImage {
                                    userStore.deletePlace(userStorePlaceId)
                                }
                            }
                        }
                        userStore.user.bookmark.removeAll { $0 == "\(feedList[0].images[0].suffix(32))" }
                        userStore.updateUser(user: userStore.user)
                    } else {
                        userStore.savePlace(feedList[0]) //장소 저장 로직(사용가능)
                        userStore.user.bookmark.append("\(feedList[0].images[0].suffix(32))")
                        userStore.updateUser(user: userStore.user)
                    }
                } label: {
                    Image(systemName: userStore.user.bookmark.contains("\(feedList[0].images[0].suffix(32))") ? "pin.fill": "pin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.primary)
                        .padding(.top, 5)

                }
                .padding(.leading, 15)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(feedList[0].title)")
                        .font(.pretendardMedium16)
                        .foregroundColor(.primary)
                    Text("\(feedList[0].roadAddress)")
                        .font(.pretendardRegular12)
                        .foregroundColor(.primary)
                }
                .padding(.leading, 15)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 80)
            .background(Color.darkGraySubColor)
            
            ForEach(feedList) { feed in
                MapFeedCellView(feed: feed)
            }
        }
        .padding(.top, 20)
        
        .onAppear {
            print("MapFeedSheetView \(feedList)")
        }
    }
}

//struct MapFeedSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapFeedSheetView()
//    }
//}
