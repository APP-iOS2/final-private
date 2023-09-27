//
//  ShopInfoCardView.swift
//  Private
//
//  Created by 주진형 on 2023/09/26.
//

import SwiftUI
import Kingfisher

struct ShopInfoCardView: View {
    @ObservedObject var userStore: UserStore
    var body: some View {
        HStack {
            KFImage(URL(string:userStore.user.bookmark[0].shopImageURL)) .placeholder {
                Image(systemName: "photo")
            }
            .resizable()
            .frame(width: 80,height: 80)
            .cornerRadius(10)
            .padding(.leading,20)
            VStack(alignment: .leading) {
                Text(userStore.user.bookmark[0].name)
                    .font(.pretendardBold18)
                    .padding(.bottom, 2)
                VStack(alignment: .leading) {
                    HStack {
                        Label(
                            title: { Text(userStore.user.bookmark[0].category.categoryName)
                                    .font(.pretendardRegular14)
                            },
                            icon: { Image(systemName: "fork.knife") }
                        )
                        Text("|")
                            .font(.pretendardRegular14)
                        Label(
                            title: { Text("0") // 가게 좋아요 수 필요
                                    .font(.pretendardRegular14)
                            },
                            icon: { Image(systemName: "heart.fill") }
                        )
                            .font(.pretendardRegular14)
                        Text("|")
                            .font(.pretendardRegular14)
                        Label(
                            title: { Text("0") // 가게 북마크 수 필요
                                    .font(.pretendardRegular14)
                            },
                            icon: { Image(systemName: "bookmark.fill") }
                        )
                            .font(.pretendardRegular14)
                    }
                    Label(
                        title: { Text(userStore.user.bookmark[0].address)
                                .font(.pretendardRegular14)
                        },
                        icon: { Image(systemName: "mappin") }
                    )
                }
                .padding(.top,2)
            }
            .padding(.leading,5)
            Spacer()
            Image(systemName: "pin.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.accentColor)
                .padding(.trailing,20)
        }
    }
}

struct ShopInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShopInfoCardView(userStore: UserStore())
    }
}
