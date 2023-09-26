//
//  ShopDetailCurrentReviewView.swift
//  Private
//
//  Created by H on 2023/09/25.
//

import SwiftUI

struct ShopwDetailCurrentReviewView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<20) { index in
                        VStack(spacing: 10) {
                            ShopDetailCurrentReviewCell()
                            if index != 19 {
                                Divider()
                            }
                        }
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }
        }
    }
}

struct ShopDetailCurrentReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ShopwDetailCurrentReviewView()
    }
}

/*
 static let feed = Feed(
     writer: UserStore.user,
     images: [""],
     contents: "맛있는 맛집이에요",
     visitedShop: ShopStore.shop,
     category: [Category.koreanFood]
 )
 */

struct ShopDetailCurrentReviewCell: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
//    let dummyFeed = FeedStore.feed
    let dummyFeedImageString: String = "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg"
    let dummyUserImageString: String = "https://i.pinimg.com/564x/d7/fd/a8/d7fda819308b8998288990b28e7f509d.jpg"
    
    /// Feed에 사용자가 북마크(저장) 했는지를 체크하는 변수를 추가해야 할 것 같습니당. 파베와 연결을 위해서 Feed의 구조체에는 북마크한 유저 id들을 배열로 담는 변수만 저장하도록 하는 편이 낫다고 생각합니다. 내부 코드 안에서만 배열 안에 로그인한 유저의 id가 포함되는지, 즉 로그인한 유저가 해당 Feed를 북마크했는지 Bool로 체크하도록,,합니다,,
    @State var isBookmarked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                AsyncImage(url: URL(string: dummyUserImageString)!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 70, height: 70)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(feedStore.feedList[0].writer.name)")
                        .font(Font.pretendardBold18)
                    Text("@\(feedStore.feedList[0].writer.nickname)")
                        .font(Font.pretendardRegular16)
                }
                
                Spacer()

                Button {
                    print(#function)
                    isBookmarked.toggle()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(Color.black)
                }
                .padding(.horizontal, 2)
            }
            
            HStack(alignment: .top, spacing: 10) {
                AsyncImage(url: URL(string: dummyFeedImageString)!) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 170, height: 170)
                
                Text(feedStore.feedList[0].contents)
                    .font(Font.pretendardRegular16)
            }
        }
    }
}
