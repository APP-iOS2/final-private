//
//  ShopInfoCardView.swift
//  Private
//
//  Created by 주진형 on 2023/09/26.
//

import SwiftUI
import Kingfisher
import NMapsMap

struct ShopInfoCardView: View {
    @EnvironmentObject var userStore: UserStore
    
    @ObservedObject var postCoordinator: PostCoordinator = PostCoordinator.shared
    @StateObject private var locationSearchStore = LocationSearchStore.shared
    
    @Binding var isShowingLocation: Bool
    
    @State private var lat: String = ""
    @State private var lng: String = ""
    
    let mySavedPlaceList: [MyFeed]
    var body: some View {
        ForEach(mySavedPlaceList, id:\.self) {place in
            HStack {
                Button {
                    isShowingLocation = true
                    
                    lat = locationSearchStore.formatCoordinates(place.mapy, 2) ?? ""
                    lng = locationSearchStore.formatCoordinates(place.mapx, 3) ?? ""
                    
                    postCoordinator.coord = NMGLatLng(lat: Double(lat) ?? 0, lng: Double(lng) ?? 0)
                    postCoordinator.newMarkerTitle = place.title
                    
                    postCoordinator.moveCameraPosition()
                    postCoordinator.makeSearchLocationMarker()
                    
                } label: {
                    KFImage(URL(string:place.images[0])) .placeholder {
                        Image(systemName: "photo")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: .screenWidth * 0.2, height: .screenWidth * 0.2)
                    .cornerRadius(10)
                    .padding(.leading,7)
                    VStack(alignment: .leading) {
                        Text(place.title)
                            .font(.pretendardSemiBold16)
                            .foregroundColor(.primary)
                            .padding(.bottom, 2)
                        VStack(alignment: .leading) {
                            HStack {
                                Label(
                                    title: { Text(place.category[0])
                                            .font(.pretendardRegular14)
                                            .foregroundColor(.primary)
                                    },
                                    icon: { Image(systemName: "fork.knife").frame(width: 1).padding(.leading, 6).padding(.trailing, 4) }
                                )
                                Text("|")
                                    .font(.pretendardRegular14)
                                    .foregroundColor(.primary)
                                Label(
                                    title: { Text("0") // 가게 좋아요 수 필요
                                            .font(.pretendardRegular14)
                                            .foregroundColor(.primary)
                                    },
                                    icon: { Image(systemName: "heart.fill").frame(width: 1).padding([.leading,.trailing], 4) }
                                )
                                .font(.pretendardRegular14)
                                Text("|")
                                    .font(.pretendardRegular14)
                                    .foregroundColor(.primary)
                                HStack {
                                    Image(systemName: "bookmark.fill").frame(width: 0.5).padding([.leading,.trailing], 4)
                                    Text("0") // 가게 북마크 수 필요
                                            .font(.pretendardRegular14)
                                    }.foregroundColor(.primary)
                            }
                            .padding(.top, 3)
                            HStack{
                                Image(systemName: "mappin")
                                    .frame(width: .screenWidth * 0.001)
                                    .padding([.leading,.trailing], 4)
                                Text(place.roadAddress)
                                    .font(.pretendardRegular12)
                                    .foregroundColor(.primary)
                                    .padding(.leading,-3)
                            }
                        }
                        .padding(.top,2)
                    }
                    .padding(.leading,3)
                }
                
                Spacer()
                Button {
                    userStore.deletePlace(place)
                    userStore.user.bookmark.removeAll { $0 == "\(place.images[0].suffix(32))" }
                    userStore.updateUser(user: userStore.user)
                } label: {
                    Image(systemName: "pin.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color("AccentColor"))
                                        .padding(.trailing,7)
                }
            }
            Divider()
                .background(Color.primary)
                .frame(width: .screenWidth * 0.98)
        }
    }
}

//struct ShopInfoCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopInfoCardView(mySavedPlaceList: [MyFeed()]).environmentObject(UserStore())
//    }
//}
