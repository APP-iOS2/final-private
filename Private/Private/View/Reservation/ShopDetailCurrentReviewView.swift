//
//  ShopDetailCurrentReviewView.swift
//  Private
//
//  Created by H on 2023/09/25.
//

import SwiftUI
import NMapsMap
import Kingfisher
import ExpandableText

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

struct ShopDetailCurrentReviewCell: View {
    
    @EnvironmentObject var feedStore: FeedStore
    
    let dummyFeed = Feed(
        writer: User(),
        images: ["https://img.siksinhot.com/story/1531139130420376.jpeg?w=307&h=300&c=Y", "https://img.siksinhot.com/place/1538713349859052.jpg", "https://cdn.imweb.me/upload/S201810165bc5942bc7459/b2fbfa213965d.jpeg"],
        contents: "후르츠산도 너무 예쁘고 맛있게 생겨서 꼭 가보고싶었다!! 굉장히 애매한 위치에 있었는데 계단을 올라가보니 핫플답게 사람들도 많고 인스타감성의 카페 느낌이 물씬났다!! 1인 1음료이고 후르츠산도까지 먹으면 가격이 조금 부담되지만 음료 맛이 좋았다!! 후르츠산도는 내가 너무 기대를 했던건지 크림 맛도 약간 밍밍하고 좀 질리는 느낌? 이였지만 과일은 싱싱하고 맛있었다 그치만 너무 비쌈.... 직원분들 친절하시고 테이블회전은 약간 느린듯 하여 웨이팅이 점점 늘어났다.. 한 번 가본걸로 만족!!",
        visitedShop: Shop(name: "ㅂㅋㅅ", category: .cafe, coord: NMGLatLng(lat: 36.444, lng: 127.332), address: "서울특별시 중구 을지로길", addressDetail: "20 2층", shopTelNumber: "02-2222-2222", shopInfo: "커피와 디저트, 와인, 맥주, 칵테일을 판매하는 카페 겸 문화 휴식 공간입니다. 후루츠 산도는 촉촉한 식빵 사이에 부드럽고 달콤한 크림과 망고, 바나나, 키위, 딸기를 샌드한 것으로 폭신폭신한 식감으로 인기가 가장 좋은 메뉴입니다. 애완동물 동반도 가능한 카페입니다.", shopImageURL: "https://image.bugsm.co.kr/album/images/500/40912/4091237.jpg", bookmarks: [], menu: [], regularHoliday: [], temporayHoliday: [], breakTimeHours: [:], weeklyBusinessHours: [:]),
        category: [.cafe, .brunch])
    
    /// Feed에 사용자가 북마크(저장) 했는지를 체크하는 변수를 추가해야 할 것 같습니당. 파베와 연결을 위해서 Feed의 구조체에는 북마크한 유저 id들을 배열로 담는 변수만 저장하도록 하는 편이 낫다고 생각합니다. 내부 코드 안에서만 배열 안에 로그인한 유저의 id가 포함되는지, 즉 로그인한 유저가 해당 Feed를 북마크했는지 Bool로 체크하도록,,합니다,,
    @State var isBookmarked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                KFImage(URL(string: dummyFeed.writer.profileImageURL)!)
                    .placeholder({
                        ProgressView()
                    })
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(dummyFeed.writer.name)")
                        .font(Font.pretendardBold18)
                    Text("@\(dummyFeed.writer.nickname)")
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(dummyFeed.images, id: \.self) { imageURL in
                            KFImage(URL(string: imageURL)!)
                                .placeholder({
                                    ProgressView()
                                })
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                        }
                    }
                }
                .frame(width: 150, height: 150)
                
                ExpandableText(text: dummyFeed.contents)
                    .font(Font.pretendardRegular14)
                    .lineLimit(9)
                    .expandAnimation(.easeOut)
                    .expandButton(TextSet(text: "더보기", font: Font.pretendardRegular16, color: .blue))
                    .collapseButton(TextSet(text: "접기", font: Font.pretendardRegular16, color: .blue))
            }
        }
    }
}
